Return-Path: <fio-owner@vger.kernel.org>
Received: from serv132.fzu.cz ([147.231.26.132]:56685 "EHLO serv132.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab3CKQBa (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 11 Mar 2013 12:01:30 -0400
Message-ID: <513DFD85.2080107@cesnet.cz>
Date: Mon, 11 Mar 2013 16:51:33 +0100
From: Jiri Horky <jiri.horky@cesnet.cz>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] Add a simple test for LFSR generator
References: <1362746224-5162-1-git-send-email-apyrgio@grnet.gr> <1362746224-5162-3-git-send-email-apyrgio@grnet.gr>
In-Reply-To: <1362746224-5162-3-git-send-email-apyrgio@grnet.gr>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms050006040300040200020609"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Alex Pyrgiotis <apyrgio@grnet.gr>
Cc: fio@vger.kernel.org, synnefo-devel@googlegroups.com

This is a cryptographically signed message in MIME format.

--------------ms050006040300040200020609
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Alex,

I just used your implementation in a different project as well, thanks=20
for it :) One small correction, I think that the last line of:

On 03/08/2013 01:37 PM, Alex Pyrgiotis wrote:
> +	/* Check if all expected numbers within range have been calculated */=

> +	r =3D 0;
> +	if (verify) {
> +		fprintf(stderr, "Verifying results... ");
> +		for (i =3D 0; i < numbers; i++) {
> +			if (*(uint8_t *)(v + 1) !=3D 1) {
should be:

			if (*(uint8_t *)(v + i) !=3D 1) {

(not +1, but +i).


Regards
Jiri Horky



--------------ms050006040300040200020609
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJzTCC
BNowggPCoAMCAQICEF3/UOr+D1NGiJ+AQY/nQsgwDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNV
BAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UEBxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8GA1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3Qu
Y29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
RW1haWwwHhcNMDkwNTE4MDAwMDAwWhcNMjgxMjMxMjM1OTU5WjBEMQswCQYDVQQGEwJOTDEP
MA0GA1UEChMGVEVSRU5BMSQwIgYDVQQDExtURVJFTkEgZVNjaWVuY2UgUGVyc29uYWwgQ0Ew
ggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDEvCV9ze9ZBKt0Jym2Y4rvxDVwoUYI
r25QmxtxeJcChcA1/5AYEWb6MzkUnqQS9z3uBSyB5/ctLjZ4Qw45tn96dMPLVT8vs8vDN2rh
lQMjG7MimBODWDBfrDyRRdNtCy7L0ZFhsspx+sKJDHsJ1pK/o4EXEVUg3zeBnx4mCR3SFxlD
y4uZJXRBW+YyKtCnU9zSIY3Nkc97bPTJ/tDl0gZrGmFCG4CRB9wUSSc7Coqy4jtpCITLgZnX
uhQf2H6SY732LTH6lU7NNg2Z7xG6rUr7qMR4uXxaPsj1CDLAqQXHjBoojzC6F6PxueIHp7j7
Vb+fYlrVFA8ItBOZ0hJ5WvD9AgMBAAGjggFbMIIBVzAfBgNVHSMEGDAWgBSJgmd9xJ0mcABL
tFBIfN49rgRufTAdBgNVHQ4EFgQUyIlzmaddURZTRVR8o8I5fMvXqoEwDgYDVR0PAQH/BAQD
AgEGMBIGA1UdEwEB/wQIMAYBAf8CAQAwJgYDVR0gBB8wHTANBgsrBgEEAbIxAQICHTAMBgoq
hkiG90wFAgIFMFgGA1UdHwRRME8wTaBLoEmGR2h0dHA6Ly9jcmwudXNlcnRydXN0LmNvbS9V
VE4tVVNFUkZpcnN0LUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kRW1haWwuY3JsMG8GCCsGAQUF
BwEBBGMwYTA4BggrBgEFBQcwAoYsaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VUTkFBQUNs
aWVudF9DQS5jcnQwJQYIKwYBBQUHMAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJ
KoZIhvcNAQEFBQADggEBAAgXpBz5FWuwGWFvoEjjeiTvQVWaoFBw2CPVU4ZKZ47o2lYWGCwb
GCGJupgk7lY04xeGJr0hWtQZk0rqYXRNtsSEjUfuyi5lbTaTmLHikmaI4k57dcdeRGkh3BJq
MPxhgP4P8J3S3H6u5cJTTQtwg2FWRfs933L2AkJ164iKmFdg9Z+ickmxej5BZzXDVSsNBzXo
xivVuod5gHTnkja9RoF6Liniar7hFxM1fBakJTMvYe7OyVLgQNvTvjlaz89MFOV/xUNXi025
Wo7CDwZN3shJnYFzuuQ/mKWTPFlO25s13/5Nv1Wh6WTDRXysj3xH0TrxTnXZkGdA6LEvnhcv
XDUwggTrMIID06ADAgECAhEApf39CtUIjwuN5j5HTKY3rTANBgkqhkiG9w0BAQUFADBEMQsw
CQYDVQQGEwJOTDEPMA0GA1UEChMGVEVSRU5BMSQwIgYDVQQDExtURVJFTkEgZVNjaWVuY2Ug
UGVyc29uYWwgQ0EwHhcNMTIwNzA4MDAwMDAwWhcNMTMwODA3MjM1OTU5WjB6MRMwEQYKCZIm
iZPyLGQBGRYDb3JnMRYwFAYKCZImiZPyLGQBGRYGdGVyZW5hMRMwEQYKCZImiZPyLGQBGRYD
dGNzMQswCQYDVQQGEwJDWjEPMA0GA1UEChMGQ0VTTkVUMRgwFgYDVQQDEw9KaXJpIEhvcmt5
IDM1NzAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCg8wMmAhMj1XlnTCodY9oX
dNX7yl46jJBsDDEYQ6En2V9sW+5jTu76OQQDHqiMtiPTQCyAXxzgjpwOZvHGLdJ2mqTCno0I
HYPz06saTkVT6BFunkcWtk+00Yx1j+VYVrvXydXYOKQRWkPYqUwHMzgujw7yu40jsVDNkPMF
YBUrQGbdt8u3JMRe4oinhqbQ1pkr9hWlpbry/z7qaHU/kc9eAXri/rnX3dxu7KZ9J0uXDCv0
H5bWxr55V8ljbQd2QhVhK7qvt8lSvteO9gnkXF9TTNuqXSxd87qFJfDRHCoTGt4YueFR0Wco
5sJjrsC7sgO1uo16CEGm7eitOFQsLR9ZAgMBAAGjggGgMIIBnDAfBgNVHSMEGDAWgBTIiXOZ
p11RFlNFVHyjwjl8y9eqgTAdBgNVHQ4EFgQUkbmrZa257WAMwQ2skZS6GZEBDsQwDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYBBQUHAwQGCCsGAQUFBwMC
MCYGA1UdIAQfMB0wDQYLKwYBBAGyMQECAh0wDAYKKoZIhvdMBQICBTBHBgNVHR8EQDA+MDyg
OqA4hjZodHRwOi8vY3JsLnRjcy50ZXJlbmEub3JnL1RFUkVOQWVTY2llbmNlUGVyc29uYWxD
QS5jcmwwegYIKwYBBQUHAQEEbjBsMEIGCCsGAQUFBzAChjZodHRwOi8vY3J0LnRjcy50ZXJl
bmEub3JnL1RFUkVOQWVTY2llbmNlUGVyc29uYWxDQS5jcnQwJgYIKwYBBQUHMAGGGmh0dHA6
Ly9vY3NwLnRjcy50ZXJlbmEub3JnMDAGA1UdEQQpMCeBD2hvcmt5QGNlc25ldC5jeoEUamly
aS5ob3JreUBjZXNuZXQuY3owDQYJKoZIhvcNAQEFBQADggEBAHu0bZ0NLpzNMr273/FCoIPe
GG620A1kwk/aM/FCAgb648z3Q/vQgAvJnQh3ryhE7YaIyXRwVcV0POeFSRWdbSTuxUywfd3k
udVxnfP5A8BKtIVMsFd404RB8n0Imwjrbyd7eJEUA+FKFK+OphVDPBjg5s+4MVK+nT5ews8V
vOswa9DCfdhxRkbwBDAhZUkekDuxNR+VXHSo6ADYOCg3+3kg4vwCcYV93t+UPfkAXN6IhPb/
QJGahilFSjHb4x7dfDWAQtBmbBCSlDpycLoqWjFMEOMIwyOsog7PE1sHlwokZbtz6e60Xdph
iwYxpUxj4bhwDGpP8sD9ki9REoYThlsxggMlMIIDIQIBATBZMEQxCzAJBgNVBAYTAk5MMQ8w
DQYDVQQKEwZURVJFTkExJDAiBgNVBAMTG1RFUkVOQSBlU2NpZW5jZSBQZXJzb25hbCBDQQIR
AKX9/QrVCI8LjeY+R0ymN60wCQYFKw4DAhoFAKCCAaEwGAYJKoZIhvcNAQkDMQsGCSqGSIb3
DQEHATAcBgkqhkiG9w0BCQUxDxcNMTMwMzExMTU1MTMzWjAjBgkqhkiG9w0BCQQxFgQUuPvW
+HJf8JRN+yK+diyQaxW8dJwwaAYJKwYBBAGCNxAEMVswWTBEMQswCQYDVQQGEwJOTDEPMA0G
A1UEChMGVEVSRU5BMSQwIgYDVQQDExtURVJFTkEgZVNjaWVuY2UgUGVyc29uYWwgQ0ECEQCl
/f0K1QiPC43mPkdMpjetMGoGCyqGSIb3DQEJEAILMVugWTBEMQswCQYDVQQGEwJOTDEPMA0G
A1UEChMGVEVSRU5BMSQwIgYDVQQDExtURVJFTkEgZVNjaWVuY2UgUGVyc29uYWwgQ0ECEQCl
/f0K1QiPC43mPkdMpjetMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUDBAEqMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggEAAPBvAGBy111G/XIdzenmsFOj
rQdAbEHutCnItj2zareYdF8QPQhLdPCbxn5jjNHg/l4UQulKRuQWDFO3Jm7xg3Hr0+Jf07n0
lkZ6FQnvxs81GwEVyHj36iL+d23C56LaL2KYT9++aF5c4EMGHywZeV2m977J1mTHGFNf5bWM
IPwID08j4U3Kjnu/zktyX0UadUEVDNOSE80CEvisCvojNrkt0Z2jnIYSHK+oReuXhWr+TOrk
mxc21AYxy+erW8qNR5RtALe/K+UjX9vSifegthZEQLJ+N9sSaIHVnOBRMW/l+9UUkiCGwX+1
0NvVKJjKGA1h8J6Lz+05wEIpw7VwxwAAAAAAAA==
--------------ms050006040300040200020609--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


