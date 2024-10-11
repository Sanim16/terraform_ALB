#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo " " > /var/www/html/index.html #This overwrites the default index.html file
cat <<EOT >> /var/www/html/index.html
<!DOCTYPE html>
<html>
<title>Sample site deployed with Terraform</title>
<body>

<h1>Hello World from $(hostname -f)</h1>
<p>

This site was deployed with Terraform to an EC2 instance fronted by an Application Load balancer.
It's a basic page deployed by the userdata script, You could put an instruction to get the site from S3 for a full site.
<br>
</p>
<p>
Cheers and have a good day

</p>

</body>
</html>
EOT
