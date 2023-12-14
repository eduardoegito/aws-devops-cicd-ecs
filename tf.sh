#!/bin/bash

command=$1
PROJECT_NAME=$2

export TF_VAR_project_name=${PROJECT_NAME}
export TF_VAR_image_tag_prefix=${PROJECT_NAME}
export TF_VAR_codecommit_repo_name=${PROJECT_NAME}
export TF_VAR_ecr_repo_name=${PROJECT_NAME}
export TF_VAR_codebuild_project_name=codebuild_${PROJECT_NAME}
export TF_VAR_codebuild_service_role_name=codebuild-service-role_${PROJECT_NAME}
export TF_VAR_codepipeline_pipeline_name=codepipeline_${PROJECT_NAME}
export TF_VAR_codepipeline_role_name=codepipeline_role_${PROJECT_NAME}
export TF_VAR_codepipeline_role_policy_name=${TF_VAR_codepipeline_role_name}_policy
export TF_VAR_cloudwatch_events_role_name=cloudwatch_events_role_${PROJECT_NAME}
export TF_VAR_cloudwatch_events_role_policy_name=${TF_VAR_cloudwatch_events_role_name}_policy
export TF_VAR_cloudwatch_events_rule_name=trigger_pipeline_${PROJECT_NAME}
export TF_VAR_codebuild_cloudwatch_logs_group_name=loggroup_${PROJECT_NAME}
export TF_VAR_codebuild_cloudwatch_logs_stream_name=logstream_${PROJECT_NAME}

export TF_VAR_codecommit_repo_default_branch_name="main"

case ${command} in
    plan )
       terraform init
       terraform plan -no-color -out latest-${TF_VAR_project_name}.tfplan
       ;;
    apply )
       terraform init
       terraform apply -no-color latest-${TF_VAR_project_name}.tfplan
       rm latest-${TF_VAR_project_name}.tfplan
       ;;
    init )
       terraform init
       ;;
    destroy )
       terraform init
       terraform destroy -auto-approve -no-color
       ;;
    show )
       terraform init
       terraform show -no-color latest-${TF_VAR_project_name}.tfplan
       ;;
    nothing )
      echo "nothing done"
      ;;
    * )
       terraform ${command} -no-color
       ;;
esac