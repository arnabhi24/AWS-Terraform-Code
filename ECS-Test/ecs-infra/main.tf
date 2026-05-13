############################################
# Load Balancer (Shared ALB)
############################################
module "alb" {
  source  = "./modules/alb"

  name    = "shared-alb"
  lb_type = var.load_balancer_type
  subnets = var.public_subnets
  vpc_id  = var.vpc_id
}

############################################
# ECR
############################################
module "frontend_ecr" {
  source = "./modules/ecr"
  name   = "iym-prod-cluster/scp-login-frontend"
}

############################################
# ECS Cluster
############################################
module "ecs_cluster" {
  source = "./modules/ecs-cluster"
  name = var.ecs_cluster_name
}

############################################
# IAM Roles (Execution + Task Role)
############################################
module "iam" {
  source = "./modules/iam"
}

############################################
# ECS Task Definition (Frontend)
############################################
module "frontend_task" {
  source = "./modules/ecs-task"

  family             = "frontend-task"
  cpu                = "512"
  memory             = "1024"
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn      = module.iam.task_role_arn
  enable_efs         = false

  container_definitions = [
    {
      name      = "frontend"
      image     = "${module.frontend_ecr.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/frontend-task"
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "ecs"
        awslogs-create-group  = "true"
        mode                  = "non-blocking"
        max-buffer-size       = "25m"
      }
    }
    }
  ]
}

############################################
# ECS Service + Target Group + Listener Rule
############################################
module "frontend_service" {
  source = "./modules/ecs-service"

  name                = "frontend"
  cluster_arn         = module.ecs_cluster.arn
  task_definition_arn = module.frontend_task.arn
  desired_count       = 0

  vpc_id   = var.vpc_id
  subnets  = var.private_subnets

  container_name = "frontend"
  container_port = 80

  alb_sg_id    = module.alb.alb_sg_id
  listener_arn = module.alb.http_listener_arn

  path_patterns = ["/*"]
  priority      = 10

  # 🔹 ADD THIS (Ingress from ALB only)
  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = []
      source_security_group_id = module.alb.alb_sg_id
    }
  ]

  # 🔹 ADD THIS (Outbound to anywhere)
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}