
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 


echo -e "${BLUE}Step 1: Updating kubeconfig for EKS cluster...${NC}"
aws eks --region us-east-1 update-kubeconfig --name EKS_Cluster
echo -e "${GREEN}Done updating kubeconfig.${NC}\n"


echo -e "${BLUE}Step 2: Downloading kubectl...${NC}"
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.34.1/2025-09-19/bin/linux/amd64/kubectl
echo -e "${GREEN}kubectl downloaded.${NC}\n"


echo -e "${BLUE}Step 3: Making kubectl executable...${NC}"
chmod +x ./kubectl
echo -e "${GREEN}kubectl is now executable.${NC}\n"


echo -e "${BLUE}Step 4: Installing kubectl in \$HOME/bin and updating PATH...${NC}"
mkdir -p $HOME/bin
cp ./kubectl $HOME/bin/kubectl
export PATH=$HOME/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
echo -e "${GREEN}kubectl installed and PATH updated.${NC}\n"


echo -e "${BLUE}Step 5: Labeling nodes...${NC}"
kubectl get nodes | awk '
NR==2 {
    print "\033[1;33mLabeling node "$1" with eks=jenkins\033[0m";
    system("kubectl label node "$1" eks=jenkins")
}
NR==3 {
    print "\033[1;33mLabeling node "$1" with eks=app\033[0m";
    system("kubectl label node "$1" eks=app")
}'
echo -e "${GREEN}Nodes labeled successfully.${NC}"



files=(
  "app-namespace.yaml"
  "jenkins-namespace.yaml"
  "jenkins-app-sa.yaml"
  "StorageClass-EBS.yaml"
  "jenkins-pvc.yaml"
  "jenkins-pod.yaml"
  "jenkins-service.yaml"
)

for file in "${files[@]}"; do
  echo -e "${BLUE}Applying $file...${NC}"
  
  if kubectl apply -f "$file"; then
    echo -e "${GREEN}✅ $file applied successfully.${NC}\n"
  else
    echo -e "${YELLOW}⚠️ $file failed or already exists. Skipping...${NC}\n"
  fi

done