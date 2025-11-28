# set vars
AWS_REGION=ap-south-1
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# login
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# backend
cd backend
docker build -t flask-backend:latest .
docker tag flask-backend:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/flask-backend-repo:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/flask-backend-repo:latest

# frontend
cd ../frontend
docker build -t express-frontend:latest .
docker tag express-frontend:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/express-frontend-repo:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/express-frontend-repo:latest
