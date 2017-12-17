<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ds="urn:jboss:domain:datasources:4.0"
                xmlns:ut="urn:jboss:domain:undertow:3.0"
                xmlns:ejb="urn:jboss:domain:ejb3:4.0">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ds:subsystem/ds:datasources">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:element name="datasource" namespace="urn:jboss:domain:datasources:4.0">
                <xsl:attribute name="jndi-name">java:jboss/datasources/MySQLDS</xsl:attribute>
                <xsl:attribute name="pool-name">MySQLDS</xsl:attribute>
                <xsl:attribute name="enabled">true</xsl:attribute>
                <xsl:attribute name="use-java-context">true</xsl:attribute>
                <xsl:attribute name="use-ccm">true</xsl:attribute>
                <xsl:element name="connection-url" namespace="urn:jboss:domain:datasources:4.0">jdbc:mysql://${env.DB_PORT_3306_TCP_ADDR:db}:${env.DB_PORT_3306_TCP_PORT:3306}/${env.DB_ENV_MYSQL_DATABASE:test}?verifyServerCertificate=${env.DB_VERIFY_SERVER_CERTIFICATE:false}&amp;useSSL=${env.DB_USE_SSL:false}&amp;requireSSL=${env.DB_REQUIRE_SSL:false}</xsl:element>
                <xsl:element name="driver" namespace="urn:jboss:domain:datasources:4.0">mysql</xsl:element>
                <xsl:element name="pool" namespace="urn:jboss:domain:datasources:4.0">
                    <xsl:element name="min-pool-size" namespace="urn:jboss:domain:datasources:4.0">${env.DB_MIN_POOL_SIZE:1}</xsl:element>
                    <xsl:element name="max-pool-size" namespace="urn:jboss:domain:datasources:4.0">${env.DB_MAX_POOL_SIZE:10}</xsl:element>
                    <xsl:element name="prefill" namespace="urn:jboss:domain:datasources:4.0">${env.DB_PREFILL_POOL:false}</xsl:element>
                </xsl:element>
                <xsl:element name="security" namespace="urn:jboss:domain:datasources:4.0">
                    <xsl:element name="user-name" namespace="urn:jboss:domain:datasources:4.0">${env.DB_ENV_MYSQL_USER:jboss}</xsl:element>
                    <xsl:element name="password" namespace="urn:jboss:domain:datasources:4.0">${env.DB_ENV_MYSQL_PASSWORD:jboss}</xsl:element>
                </xsl:element>
                <xsl:element name="validation" namespace="urn:jboss:domain:datasources:4.0">
                    <xsl:element name="check-valid-connection-sql" namespace="urn:jboss:domain:datasources:4.0">SELECT 1</xsl:element>
                    <xsl:element name="background-validation" namespace="urn:jboss:domain:datasources:4.0">true</xsl:element>
                    <xsl:element name="background-validation-millis" namespace="urn:jboss:domain:datasources:4.0">60000</xsl:element>
                </xsl:element>
                <xsl:element name="pool" namespace="urn:jboss:domain:datasources:4.0">
                    <xsl:element name="flush-strategy" namespace="urn:jboss:domain:datasources:4.0">IdleConnections</xsl:element>
                </xsl:element>
            </xsl:element>

        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ds:subsystem/ds:datasources/ds:drivers">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:element name="driver" namespace="urn:jboss:domain:datasources:4.0">
                <xsl:attribute name="name">mysql</xsl:attribute>
                <xsl:attribute name="module">com.mysql.jdbc</xsl:attribute>
                <xsl:element name="xa-datasource-class" namespace="urn:jboss:domain:datasources:4.0">com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xsl:element>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ut:subsystem/ut:server[@name='default-server']/ut:http-listener[@name='default']">
        <xsl:copy>
            <xsl:attribute name="proxy-address-forwarding">${env.PROXY_ADDRESS_FORWARDING:false}</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ejb:subsystem/ejb:timer-service/ejb:data-stores">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <xsl:element name="database-data-store" namespace="urn:jboss:domain:ejb3:4.0">
                <xsl:attribute name="name">database-clustered-store</xsl:attribute>
                <xsl:attribute name="datasource-jndi-name">java:jboss/datasources/MySQLDS</xsl:attribute>
                <xsl:attribute name="database">mysql</xsl:attribute>
                <xsl:attribute name="partition">timer</xsl:attribute>
                <xsl:attribute name="refresh-interval">60000</xsl:attribute>
                <xsl:attribute name="allow-execution">true</xsl:attribute>
            </xsl:element>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>