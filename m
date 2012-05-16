Return-Path: <fio-owner@vger.kernel.org>
Received: from serv132.fzu.cz ([147.231.26.132]:51729 "EHLO serv132.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591Ab2EPVLM (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 16 May 2012 17:11:12 -0400
Message-ID: <4FB417E0.5080802@cesnet.cz>
Date: Wed, 16 May 2012 23:10:56 +0200
From: Jiri Horky <jiri.horky@cesnet.cz>
MIME-Version: 1.0
Subject: Re: blktrace with fio replay for benchmarking vendor offerings
References: <4FB3FE27.3030302@usit.uio.no>
In-Reply-To: <4FB3FE27.3030302@usit.uio.no>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010603020708050601010403"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: =?ISO-8859-1?Q?Jarle_Bj=F8rgeengen?= <jarle.bjorgeengen@usit.uio.no>
Cc: fio@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms010603020708050601010403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Jarle,

On 05/16/2012 09:21 PM, Jarle Bj=F8rgeengen wrote:
> Hello,
>
> I'm involved in the purchasing process of block storage systems, and=20
> research viable benchmarking strategies for specifying and verifying=20
> performance requirements.
>
> Ideally I would like to capture our traces of our current daily=20
> production workload  with blktrace, attach the traces to the tender=20
> and require the configuration to be able to run 2x that kind of=20
> workload. During acceptance I would like to hook enough hardware to=20
> saturate the system with the same workload, and measure that the=20
> requirement has been met.
>
> I'm interested in comments about the practical viability of such=20
> approach if anyone have similar experiences.
>
actually, I am in the very same situation at Institute of Physics, where =

we annually buy some 1PB of raw disk space (the money equivalent). We=20
ended up with very similar approach that you described. We use IOreplay=20
from IOapps (http://code.google.com/p/ioapps/) application to run the=20
load previously recorded by strace. So it is done on a file level=20
instead of the block level. This clearly has its advantages (you may use =

different file system, benchmarks are not fatal for running systems=20
etc.), but of course some drawbacks as well (strace overhead, etc., see=20
webpage). If you are interested and have any more question/suggestion=20
about the IOreplay, just email me, I actually wrote it as a part of my=20
master thesis.
> Some open questions:
>
> How safe is it to run blktrace on critical production environment?=20
> What precautions should be made?
>
> Given that the current system consists of 3 HP EVA800 with X number of =

> LUNS about 50 hosts, and the new system likely is a single system with =

> 5 new servers running at at full speed, how much value will the=20
> benchmark provide compared to "real world" ? Should I create equally=20
> many luns and distribute load across the 5 machines?
>
> Is it best to scale the workload to 2X replaying all traces=20
> simultanously with one fio-trace-replay/lun, and then dublicate alle=20
> replays so that each lun serves two fio-replays rather than one, and=20
> then 3 and so on.
>
> Any thoughts or comments are very much appreciated.
I would say that all above heavily depends on your environment, whether=20
the access pattern is similar to all LUNS and whether all LUNS are more=20
or less expected to expand similarly in the future. Personally, I would=20
go with settings that are simpler to setup (from the options you have=20
proposed) unless you really know your future requirements and you are=20
sure that the results obtained in both ways differ significantly.

Regards
Jiri Horky


--------------ms010603020708050601010403
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIISxDCC
BGYwggNOoAMCAQICEFEmCpMc4n+cw6VfeeByroIwDQYJKoZIhvcNAQEFBQAwgZMxCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMRswGQYDVQQDExJVVE4gLSBEQVRBQ29ycCBTR0MwHhcNMDUwNjA3MDgwOTEwWhcNMTkw
NjI0MTkwNjMwWjBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNV
BAsTHUFkZFRydXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBF
eHRlcm5hbCBDQSBSb290MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt/caM+by
AAQtOeBOW+0fvGwPzbX6I7bO3psRM5ekKUx9k5+9SryT7QMa44/P5W1QWtaXKZRagLBJetsu
lf24yr83OC0ePpFBrXBWx/BPP+gynnTKyJBU6cZfD3idmkA8Dqxhql4Uj56HoWpQ3NeaTq8F
s6ZxlJxxs1BgCscTnTgHhgKo6ahpJhiQq0ywTyOrOk+E2N/On+Fpb7vXQtdrROTHre5tQV9y
WnEIN7N5ZaRZoJQ39wAvDcKSctrQOHLbFKhFxF0qfbe01sTurM0TRLfJK91DACX6Yblpalgj
EbenM49WdVn1zSnXRrcKK2W200JvFbK4e/vv6V1T1TRaJwIDAQABo4HYMIHVMB8GA1UdIwQY
MBaAFFMy0bPPf/rg8aBdhU6S0p5FHbRPMB0GA1UdDgQWBBStvZh6NLQm9/rEJlTvA73gJMtU
GjAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zARBglghkgBhvhCAQEEBAMCAQIw
IAYDVR0lBBkwFwYKKwYBBAGCNwoDAwYJYIZIAYb4QgQBMD0GA1UdHwQ2MDQwMqAwoC6GLGh0
dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9VVE4tREFUQUNvcnBTR0MuY3JsMA0GCSqGSIb3DQEB
BQUAA4IBAQDG7lMXaBSyUSIekFgNlP298XDlhi3DNjGPVEhG5y0IN7xsCmDhDq1RNOASk+m+
uKu4JrTplj0oj65kB/7gAezF45HrGKDxdX7bCuafkduvrnXfI5Fo3RcAWkv/ZGxw6wEa0JDZ
x6bWbfYT5P+1ydIeKsuxJUMmeNkwm04NHr5p79/q/i2zzPmw3bUUypHUsrWl+wEZo0d5n52M
lYc0+B84kto2phH6a+tr6dxFeBU5BtdNQeQhyNwvh9G3v0hgdaViyyTeO2GgKSCmvsVsnMTp
Cmki75E6+iav0VtBpzri+DgHQqvBW/jObboPBD8yNKzcBCjXcDAUJgbE5JuY1c94MIIEijCC
A3KgAwIBAgIQJ/TqEfR6hsRunbtuqRcHBzANBgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJT
RTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRydXN0IEV4dGVybmFsIFRU
UCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBSb290MB4XDTA1MDYw
NzA4MDkxMFoXDTIwMDUzMDEwNDgzOFowga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEX
MBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29y
azEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNF
UkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCyOYWk8n2rQTtiRjeuzcFgdbw5ZflKGkeiucxIzGqY1U01Gbmk
QuXOSeKKLx580jEHx060g2SdLinVomTEhb2FUTV5pE5okHsceqSSqBfymBXyk8zJpDKVuwxP
ML2YoAuL5W4bokb6eLyib6tZXqUvz8rabaov66yhs2qqty5nNYt54R5piOLmRs2gpeq+C852
OnoOm+r82idbPXMfIuZIYcZM82mxqC4bttQxICy8goqOpA6l14lD/BZarx1x1xFZ2rqHDa/6
8+HC8KTFZ4zW1lQ63gqkugN3s2XI/R7TdGKqGMpokx6hhX71R2XL+E1XKHTSNP8wtu72YjAU
jCzrAgMBAAGjgeEwgd4wHwYDVR0jBBgwFoAUrb2YejS0Jvf6xCZU7wO94CTLVBowHQYDVR0O
BBYEFImCZ33EnSZwAEu0UEh83j2uBG59MA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTAD
AQH/MHsGA1UdHwR0MHIwOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FkZFRydXN0
RXh0ZXJuYWxDQVJvb3QuY3JsMDagNKAyhjBodHRwOi8vY3JsLmNvbW9kby5uZXQvQWRkVHJ1
c3RFeHRlcm5hbENBUm9vdC5jcmwwDQYJKoZIhvcNAQEFBQADggEBABnYiRFvKKymAKLnh8Gb
kAPbfqES/R7z4vABqZRUQmuaCcSgbdeQkgQDZnlDcfz4b6/bdkXiNxo93eRZBHisHPSDRvN6
z1uEci3lRsG6GBEp88tJeYc8um0FnaRtaE+tchQ2qLmx/b/Pf/CkapQ1UI/PgW1Vsd1ZMErf
baCcZB9JfO82u/TjafT4OY9arUuFOrcO7dPPDUSi+wS/5C9wjiX7WlQGs9DEvG2N+3MyLOmb
hCQt1n+RemgCUB8OP03pzPW7Z+jcHC47/E7N/gKO46gTCqUmRGXpEPJNUqeu3D7KazJcQWz+
9V2g6v/R+puGWG09lkfl/i6VBMIAzI6h8rswggTaMIIDwqADAgECAhBd/1Dq/g9TRoifgEGP
50LIMA0GCSqGSIb3DQEBBQUAMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAVBgNV
BAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxITAf
BgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJGaXJz
dC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMB4XDTA5MDUxODAwMDAwMFoXDTI4
MTIzMTIzNTk1OVowRDELMAkGA1UEBhMCTkwxDzANBgNVBAoTBlRFUkVOQTEkMCIGA1UEAxMb
VEVSRU5BIGVTY2llbmNlIFBlcnNvbmFsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIB
CgKCAQEAxLwlfc3vWQSrdCcptmOK78Q1cKFGCK9uUJsbcXiXAoXANf+QGBFm+jM5FJ6kEvc9
7gUsgef3LS42eEMOObZ/enTDy1U/L7PLwzdq4ZUDIxuzIpgTg1gwX6w8kUXTbQsuy9GRYbLK
cfrCiQx7CdaSv6OBFxFVIN83gZ8eJgkd0hcZQ8uLmSV0QVvmMirQp1Pc0iGNzZHPe2z0yf7Q
5dIGaxphQhuAkQfcFEknOwqKsuI7aQiEy4GZ17oUH9h+kmO99i0x+pVOzTYNme8Ruq1K+6jE
eLl8Wj7I9QgywKkFx4waKI8wuhej8bniB6e4+1W/n2Ja1RQPCLQTmdISeVrw/QIDAQABo4IB
WzCCAVcwHwYDVR0jBBgwFoAUiYJnfcSdJnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFMiJc5mn
XVEWU0VUfKPCOXzL16qBMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMCYG
A1UdIAQfMB0wDQYLKwYBBAGyMQECAh0wDAYKKoZIhvdMBQICBTBYBgNVHR8EUTBPME2gS6BJ
hkdodHRwOi8vY3JsLnVzZXJ0cnVzdC5jb20vVVROLVVTRVJGaXJzdC1DbGllbnRBdXRoZW50
aWNhdGlvbmFuZEVtYWlsLmNybDBvBggrBgEFBQcBAQRjMGEwOAYIKwYBBQUHMAKGLGh0dHA6
Ly9jcnQudXNlcnRydXN0LmNvbS9VVE5BQUFDbGllbnRfQ0EuY3J0MCUGCCsGAQUFBzABhhlo
dHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBBQUAA4IBAQAIF6Qc+RVrsBlh
b6BI43ok70FVmqBQcNgj1VOGSmeO6NpWFhgsGxghibqYJO5WNOMXhia9IVrUGZNK6mF0TbbE
hI1H7souZW02k5ix4pJmiOJOe3XHXkRpIdwSajD8YYD+D/Cd0tx+ruXCU00LcINhVkX7Pd9y
9gJCdeuIiphXYPWfonJJsXo+QWc1w1UrDQc16MYr1bqHeYB055I2vUaBei4p4mq+4RcTNXwW
pCUzL2HuzslS4EDb0745Ws/PTBTlf8VDV4tNuVqOwg8GTd7ISZ2Bc7rkP5ilkzxZTtubNd/+
Tb9Voelkw0V8rI98R9E68U512ZBnQOixL54XL1w1MIIE6jCCA9KgAwIBAgIQOhkExlgrlDBI
rXauLbctajANBgkqhkiG9w0BAQUFADBEMQswCQYDVQQGEwJOTDEPMA0GA1UEChMGVEVSRU5B
MSQwIgYDVQQDExtURVJFTkEgZVNjaWVuY2UgUGVyc29uYWwgQ0EwHhcNMTEwNjA4MDAwMDAw
WhcNMTIwNzA3MjM1OTU5WjB6MRMwEQYKCZImiZPyLGQBGRYDb3JnMRYwFAYKCZImiZPyLGQB
GRYGdGVyZW5hMRMwEQYKCZImiZPyLGQBGRYDdGNzMQswCQYDVQQGEwJDWjEPMA0GA1UEChMG
Q0VTTkVUMRgwFgYDVQQDEw9KaXJpIEhvcmt5IDM1NzAwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDLFeAtUK2Re8qxCvEtMyMKDCKYhu9e9TxSuAjgL1ifAdpcFshlA949pGLo
ZATdYvJtgmUZ1WQd38VUFDia0i2mwu8DyDzGdo3a/zc2FW5ic2xsS4jmESKCLkmjf2DTQxV8
RHIw9rqMimhubnvwmaCKDvoGLwuqwwNkdXUa/PmaLo+252LPlK0Ft325pO2xSYaOXIC6ssAs
M1AD1PaGN3QRfjB3liP3blOpeKd7zJoXz6Aywd553dmg2It0Qacilv4Gn+nYcht7FaliOICa
0qixcFxx9pxD2etMC475NJcNqRDe70CaGPlyLr0tSHkcPWjsuoRdYEifGhHROCg0zZjVAgMB
AAGjggGgMIIBnDAfBgNVHSMEGDAWgBTIiXOZp11RFlNFVHyjwjl8y9eqgTAdBgNVHQ4EFgQU
ioOz8ezQ7T74Io5DNvk1Zbz72cYwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYD
VR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMCMCYGA1UdIAQfMB0wDQYLKwYBBAGyMQECAh0w
DAYKKoZIhvdMBQICBTBHBgNVHR8EQDA+MDygOqA4hjZodHRwOi8vY3JsLnRjcy50ZXJlbmEu
b3JnL1RFUkVOQWVTY2llbmNlUGVyc29uYWxDQS5jcmwwegYIKwYBBQUHAQEEbjBsMEIGCCsG
AQUFBzAChjZodHRwOi8vY3J0LnRjcy50ZXJlbmEub3JnL1RFUkVOQWVTY2llbmNlUGVyc29u
YWxDQS5jcnQwJgYIKwYBBQUHMAGGGmh0dHA6Ly9vY3NwLnRjcy50ZXJlbmEub3JnMDAGA1Ud
EQQpMCeBD2hvcmt5QGNlc25ldC5jeoEUamlyaS5ob3JreUBjZXNuZXQuY3owDQYJKoZIhvcN
AQEFBQADggEBACeDvPBzQ5M5dvmb6JBEIyLrLpsXziSHzYEnOvng+wQ+DdZpEqh4bIJyi/6s
r8QS48wKe/UV5N73KSQu5dSlzARuzj9J8f4b/5vu0GvPcyzFABk/bKAIqH96GBgAjJTECLbS
hYJbxnkFrq6gsgTcPNagQpGoazyYzDaTd3YEt2JUzbkuzQLFtyU+h7UcF9hEhamkpTkOi2/x
QpApCzT7TM9b1AzCVsb9ag5+WtYABcbvuBbiF1dx7Y01PhcQsKOWGn6Osv+cF1zWQ39U0O5t
88LPLwaEseIm3fFiH+crodZkEKTUyEZkm0vz7+PIXxKbsAPEV9yfZhq2j1o7DKb9MBMxggMV
MIIDEQIBATBYMEQxCzAJBgNVBAYTAk5MMQ8wDQYDVQQKEwZURVJFTkExJDAiBgNVBAMTG1RF
UkVOQSBlU2NpZW5jZSBQZXJzb25hbCBDQQIQOhkExlgrlDBIrXauLbctajAJBgUrDgMCGgUA
oIIBkjAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMjA1MTYy
MTEwNTZaMCMGCSqGSIb3DQEJBDEWBBQx8Y5VsquckcG+lgerAMFNsi+BEjBfBgkqhkiG9w0B
CQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZI
hvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwZwYJKwYBBAGCNxAEMVowWDBEMQsw
CQYDVQQGEwJOTDEPMA0GA1UEChMGVEVSRU5BMSQwIgYDVQQDExtURVJFTkEgZVNjaWVuY2Ug
UGVyc29uYWwgQ0ECEDoZBMZYK5QwSK12ri23LWowaQYLKoZIhvcNAQkQAgsxWqBYMEQxCzAJ
BgNVBAYTAk5MMQ8wDQYDVQQKEwZURVJFTkExJDAiBgNVBAMTG1RFUkVOQSBlU2NpZW5jZSBQ
ZXJzb25hbCBDQQIQOhkExlgrlDBIrXauLbctajANBgkqhkiG9w0BAQEFAASCAQCEU+ANZdUa
D49GiTcy1ehGI0pYI/lbMxiCTLoYMWEZrI1TlmVYCThK/QMpRqPukMTIb1IZCZ8KpUNpacf5
CN4+6Mqyi97Tg43YO2GCHcOirDW/+Gew4IcuKkR1VimH3hOhLRSDc3P+6iOr57NxpFoY7Thz
tZaDUyIklqN+AwW+ZQUxTc/RX2i7vWzhI6uDf1HAHq2yttiCn0nJ+Ui5VO8XJXterKEXVRiM
iQCJzReMXOsDcLKfpuOwYJjebGrU7mOg66X8n68eO5P+kH37nT2GAN688A0deegT9S3EHvq2
R0IpirpKlEF07fUBbXmybMz23h5o+Tn0/8jujrRVRtptAAAAAAAA
--------------ms010603020708050601010403--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


