
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin $AWS_ACCOUNT.dkr.ecr.us-east-2.amazonaws.com
# aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 760924931916.dkr.ecr.us-east-2.amazonaws.com

docker build -t eshop .

docker tag eshop $AWS_ACCOUNT.dkr.ecr.us-east-2.amazonaws.com/eshop-repository:latest 
docker push $AWS_ACCOUNT.dkr.ecr.us-east-2.amazonaws.com/eshop-repository:latest

# EKS
aws eks --region us-east-2 update-kubeconfig --name aws-preprod-dev-eks

function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}

pause