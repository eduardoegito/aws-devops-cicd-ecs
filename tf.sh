#!/bin/bash

command=$1
PROJECT_NAME=$2
ENV=$3

export TF_VAR_env=${ENV}
export TF_VAR_project_name=${PROJECT_NAME}
export TF_VAR_image_tag_prefix=${PROJECT_NAME}
export TF_VAR_codecommit_repo_name=${PROJECT_NAME}_${ENV}
export TF_VAR_ecr_repo_name=${PROJECT_NAME}_${ENV}
export TF_VAR_codebuild_project_name=${PROJECT_NAME}_${ENV}_project
export TF_VAR_codebuild_service_role_name=${PROJECT_NAME}-${ENV}-codebuild-service-role
export TF_VAR_codepipeline_pipeline_name=${PROJECT_NAME}_${ENV}_project_pipeline
export TF_VAR_codepipeline_role_name=${PROJECT_NAME}_${ENV}_codepipeline_role
export TF_VAR_codepipeline_role_policy_name=${TFVAR_codepipeline_role_name}_policy
export TF_VAR_cloudwatch_events_role_name=${PROJECT_NAME}_${ENV}_cloudwatch_events_role
export TF_VAR_cloudwatch_events_role_policy_name=${TFVAR_cloudwatch_events_role_name}_policy
export TF_VAR_cloudwatch_events_rule_name=${PROJECT_NAME}_${ENV}_trigger_project_pipeline
export TF_VAR_codebuild_cloudwatch_logs_group_name=${PROJECT_NAME}_${ENV}_project_loggroup
export TF_VAR_codebuild_cloudwatch_logs_stream_name=${PROJECT_NAME}_${ENV}_project_logstream

export TF_VAR_codecommit_repo_default_branch_name="main"
export TF_VAR_codepipeline_artifacts_s3_bucket_name="caduegito-cicd-codepipeline-artifacts"

case ${command} in
    plan )
       terraform init 
       terraform plan -no-color -out latest-${TF_VAR_env}.tfplan
       ;;
    apply )
       terraform init 
       terraform apply -no-color latest-${TF_VAR_env}.tfplan
       rm latest-${TF_VAR_env}.tfplan
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
       terraform show -no-color latest-${TF_VAR_env}.tfplan
       ;;
    nothing )
      echo "nothing done"
      ;;
    * )
       terraform ${command} -no-color
       ;;
esac