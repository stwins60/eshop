aws ecr batch-delete-image \
     --repository-name eshop-repository \
     --image-ids imageDigest=sha256:265055c140bfd5af95b921af18379678c00bcf20cab5b41d4286a3abd40f4c22


function pause(){
 read -s -n 1 -p "Press any key to continue . . ."
 echo ""
}

pause