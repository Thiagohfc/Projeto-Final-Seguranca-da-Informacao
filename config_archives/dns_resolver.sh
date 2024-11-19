sudo touch Corefile
sudo chmod 777 Corefile

echo 'example.org {
    file /etc/coredns/db.example.org
    transfer {
        to * 192.168.56.2
    }
    log
    errors
    debug
}' > Corefile

sudo touch db.example.org
sudo chmod 777 db.example.org

echo '$ORIGIN example.org. @ 3600 IN SOA sns.dns.icann.org. noc.dns.icann.org. ( 2017042745 ; serial 7200 ; refresh 3600 ; retry 1209600 ; expire 3600 ; minimum )

3600 IN NS a.iana-servers.net. 3600 IN NS b.iana-servers.net.

www IN A 127.0.0.1 IN AAAA ::1' > db.example.org

sudo docker run -d -v Corefile:/etc/coredns/Corefile -v db.example.org:/etc/coredns/db.example.org --restart always -p 8053:53 -p 8053:53/udp --name dns_resolver coredns/coredns