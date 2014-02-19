rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
yum install puppet
puppet module install puppetlabs/vcsrepo
puppet module install stankevich/python
puppet module install puppetlabs/mysql

yum install git
mkdir -p /home/puppet
git clone https://github.com/SeasoningDev/Seasoning-puppet.git /home/puppet/Seasoning-puppet
ln -s /home/puppet/Seasoning-puppet/seasoning /etc/puppet/modules

read -s -p "Please provide the database password for user 'Seasoning': " db_pw

echo -e "node default {\n    \$db_pw = \"$db_pw\"\n\n    include seasoning\n}" > /etc/puppet/site.pp

echo ""
echo ""
echo "1. Place ssl key from Build files folder to /etc/ssl/seasoning.key and run 'openssl rsa -in /etc/ssl/seasoning.key -out /etc/ssl/seasoning.key'"
echo "2. Fill in Seasoning/Seasoning/secrets.py"
echo "3. Type 'puppet apply /etc/puppet/site.pp' to deploy"
echo "4. Import database: 'mysql -u Seasoning -p -h localhost seasoning < db_backup.sql'"
