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
            %{ for r in reservations ~}
            <host name="${r.name}" mac="${r.mac}" ip="${r.ip}"/>
            %{ endfor ~}
        </xsl:element>
    </xsl:template>

    <xsl:template match="/network/ip">
        <ip>
        <xsl:apply-templates select="node()|@*"/>
        </ip>
        <dnsmasq:options>
            <dnsmasq:option value='address=/apps.ocp.vtx.private/192.168.200.2'/>
        </dnsmasq:options>
    </xsl:template>
</xsl:stylesheet>
