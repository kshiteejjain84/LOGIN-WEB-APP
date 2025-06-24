FROM mysql
MAINTAINER kshiteej
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV MYSQL_DATABASE=loginwebapp
ENV MYSQL_USER=admin
ENV MYSQL_PASSWORD=12345678
EXPOSE 3306
ENTRYPOINT use loginwebapp;
ENTRYPOINT CREATE TABLE USER (
  id int(10) unsigned NOT NULL auto_increment,
  first_name varchar(45) NOT NULL,
  last_name varchar(45) NOT NULL,
  email varchar(45) NOT NULL,
  username varchar(45) NOT NULL,
  password varchar(45) NOT NULL,
  regdate date NOT NULL,
  PRIMARY KEY  (id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
