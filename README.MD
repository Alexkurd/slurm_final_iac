### Quickstart ###

Required vars:
- TF_VAR_CF_API_TOKEN [Cloudflare token](https://dash.cloudflare.com/profile/api-tokens)
- TF_VAR_gitab_token [Gitlab token](https://gitlab.com/-/profile/personal_access_tokens)  
- TF_VAR_yc_token [Yandex-OAuth token](https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb)

Deploy and Destroy manual actions can be triggered from pipelines. 

### Basic structure ### 
S3-website for UI + api.domain.com for app in k8s(ruby+redis) + postrgre.


#### Gitlab ####
Stage adds variables to project/group.

#### DNS ####
Domain should be delegated to Cloudflare.  
Stage adds root level CNAME record to public s3-bucket-website on yandex.cloud.  
SSL is provided by Cloudflare.

#### Cloud ####
The longest stage.

Creates:
- Kubernetes Cluster
- S3 buckets (x2)
- Container Registry
- Bastion instance
- Postgre managed cluster
- service accounts and networks

### Average deploy time ###
VPCs - 1-3 sec  
Subnets - 1-3 sec  
Bastion - 2-3 min  
PostrgreSQL cluster - ~10 min
Kubernetes cluster - ~10 min
