#!/bin/bash
# Use this for user data
# install httpd (linux 2023 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo " " > /var/www/html/index.html #This overwrites the default index.html file
cat <<EOT >> /var/www/html/index.html
<!DOCTYPE html>
<html>
<title>Sample site deployed with Terraform</title>
<body>

<h1>Hello World from $(hostname -f)</h1>
<p>

This is the default target group.
<br>
<a href="./path1/index.html"> Link To Target group 1</a>
<br>
<a href="./path2/index.html"> Link To Target group 2</a>
<br>
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