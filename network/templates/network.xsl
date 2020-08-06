<?xml version="1.0" ?>
<xsl:stylesheet version="1.1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:dnsmasq="http://libvirt.org/schemas/network/dnsmasq/1.0">
    <xsl:output omit-xml-declaration="yes" indent="yes"/>

    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="/network">
        <network>
        <xsl:apply-templates select="node()|@*"/>
        </network>
    </xsl:template>

    <xsl:template match="/network/ip/dhcp">
        <xsl:element name="dhcp">
            <xsl:apply-templates/>
            <host name="${hosts.loadbalancer.hostname}" mac="${hosts.loadbalancer.mac-address}" ip="${hosts.loadbalancer.ip-address}"/>

            <host name="${hosts.bootstrap.hostname}" mac="${hosts.bootstrap.mac-address}" ip="${hosts.bootstrap.ip-address}"/>

            %{ for host in hosts.masters ~}
            <host name="${host.hostname}" mac="${host.mac-address}" ip="${host.ip-address}"/>
            %{ endfor ~}

            %{ for host in hosts.workers ~}
            <host name="${host.hostname}" mac="${host.mac-address}" ip="${host.ip-address}"/>
            %{ endfor ~}

            %{ for host in hosts.infras ~}
            <host name="${host.hostname}" mac="${host.mac-address}" ip="${host.ip-address}"/>
            %{ endfor ~}
        </xsl:element>
    </xsl:template>

    <xsl:template match="/network/ip">
        <ip>
        <xsl:apply-templates select="node()|@*"/>
        </ip>
        <dnsmasq:options>
            <dnsmasq:option value="address=/apps.${dns_domain}/${hosts.loadbalancer.ip-address}"/>
        </dnsmasq:options>
    </xsl:template>
</xsl:stylesheet>
