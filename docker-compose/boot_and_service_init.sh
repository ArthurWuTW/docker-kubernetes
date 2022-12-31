docker-compose up --build --detach

# Postgres Db
# docker-compose exec postgres-db /root/init-postgres-config
# docker-compose exec postgres-db /root/init-postgres-user

# Puppet server & Puppet db
# docker-compose exec puppet-master /root/start-puppetserver-puppetdb

# Slave
# docker-compose exec puppet-slave1 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave2 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave3 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave4 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave5 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave6 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave7 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
# docker-compose exec puppet-slave8 /bin/sh -c "/opt/puppetlabs/bin/puppet agent -t"
