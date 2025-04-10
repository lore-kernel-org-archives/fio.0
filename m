Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623611EE010
	for <fio@vger.kernel.org>; Thu, 10 Apr 2025 16:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744301508; cv=none; b=WIu55oUW9lPdoQgtPS5nDJdIitSi++OAiclqNlEl6yiUl7krKyUynfebZZ8DmTnPCvEzNbhegG9aSRieq+LIda7k33cJgtdWhZkIeOOjXOw9e0P+xODz6P072SlazLAKnQhQDR+uVBcqBLJ2gYmQp99Q0LX5IQXllLa13qmmSoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744301508; c=relaxed/simple;
	bh=LlSr5aa8GBFQXhlPh8kmYMehkU3RNIIQFA+yuSd2g7k=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Content-Type; b=DI2624zl4ebuCUC3+qTx7GYzNVs2hzerpGsXjFFjcO2pAOc4x6rXjGq1Db0whSMStXuaVztlKdmcamldIpTQcq6fuBUeh4XnbwMbjaL94dyYBgOBTfHXKostp3vWKgtHmD1yCmqydPOcT5B1HU8SNlGtnykHGvVB/nZUJ7HZqm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=BY75SLad; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="BY75SLad"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-702628e34f2so9384147b3.0
        for <fio@vger.kernel.org>; Thu, 10 Apr 2025 09:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1744301505; x=1744906305; darn=vger.kernel.org;
        h=to:subject:message-id:date:thread-index:mime-version:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NkwVGm4HD17XEzvAJkmt8tOGuVsANlikte7Kd4hEvRY=;
        b=BY75SLadUbuTGoiX9PoECevbTSUOCDr4zMUCgyZOmeRT8tiae/AkLESr6LEu85wFuD
         6os2Jxzh+LDeDCw1H5C1e/JjzGN9L0sYI3IJN48SOvrXGAohR2pEMgq27VAGfaXpNwWE
         yyfVAtYhtH+PdDxvb1bgLN8Ge6RdpcMj9MgJE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744301505; x=1744906305;
        h=to:subject:message-id:date:thread-index:mime-version:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NkwVGm4HD17XEzvAJkmt8tOGuVsANlikte7Kd4hEvRY=;
        b=afzKaVj3hoIP1U0QBkCQZab/JOMTz0Jkiia04tPfbrfisOSPh7XnV2R7uABgoxO673
         GCLYW8SGfKbmvqPumNfLiGD6s6SiBbsQ/C1j/aeVUenLx+ZoWgvnrAUpPuEiQxa044no
         ZCjDAs+Sk+xb+VO56CyTxCwqlE/bjPoVb9c2TE1OiV3Ss4O6LzaYPF/LheGehjPEnr2N
         vB918gith3tRp0ZqxY0pE9WkaCgFnRnu4mkhdIZI73U6WhUpyPZkkyqU919zMWnTEdHo
         mGWAS/mmLZivA0s5QwLbx1x+6UKImNOU3bnJsodNn7viDymI4ZB5JZu0Xoh9y8UmYZPn
         0CTg==
X-Gm-Message-State: AOJu0YylOKULqhLEA9+t2GkumTMEMo+xVcqYKGFj//J/TREQJJ1l2xx8
	QNCwkvGdorfXoUgUYq6aXawbA/Q9yHGhqir2LtoihEeqRyhABLRaPGrPAX4Se/SongJEstQFLQK
	LJZ87sqtB64GOC/KcVa2pcYrjczzdizdZX0gk9VEcwAJtvTwGVltcKLgn1fL2b0uA+ElhqQ4tJS
	TX/F0VMlU3WCRwihxBB7QovOY/
X-Gm-Gg: ASbGncvqHtEirwKmWLso3Jdbsna95tdCXNPiHD3N4qj8OtIRFmFG1h491GkGpU0rrOB
	hp+PZnk3dscmrP8/9ZX5LjwNEH8o+hl95gTv8TtB3xXGs8oLZs6FI1GctmvRr9uHba/6qzMEPW8
	HdcpEoWMWHmzIqacDVtrhcIRk=
X-Google-Smtp-Source: AGHT+IFo1mIIFnUVAXm6YhylGlWHi5kFGa/EcKCAS6/QSTjzN9QOQDJBosnVBmzQMzZ53SXbpqUOC+c0c/SAhNJMeBI=
X-Received: by 2002:a0d:c204:0:b0:6fb:949b:57b with SMTP id
 00721157ae682-7054a13ca72mr45293247b3.12.1744301505049; Thu, 10 Apr 2025
 09:11:45 -0700 (PDT)
From: James Rizzo <james.rizzo@broadcom.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AduqMGOyftjBljrvS3io1oI/A49kpg==
Date: Thu, 10 Apr 2025 10:11:41 -0600
X-Gm-Features: ATxdqUEYQDQhOfmKGrPZBEAY96DuWZKJGRiVskmbevx1L6iA1rADPzIMSJ9J5QQ
Message-ID: <53e239a430d96ea6dd19cffad77584f0@mail.gmail.com>
Subject: missing status line with windows client/server
To: fio@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="0000000000009c487606326ed720"

--0000000000009c487606326ed720
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We are seeing an issue with windows fio using the client/server model where
it often doesn=E2=80=99t display the ongoing status line during a run.  I=
=E2=80=99ve been
looking into this and found that when the issue occurs,
fio_handle_clients->poll() is returning revents with POLLIN set for an fd
that has nothing pending.  This later results in a hang in
fio_handle_clients->
fio_handle_client()->fio_net_recv_cmd()->fio_recv_data()->recv() because
recv() is called with wait=3Dtrue.

Looking at the poll() function in os/windows/posix, it appears that
fds[i].revents only ever gets set, never cleared(except in the
INVALID_SOCKET case).

I=E2=80=99ve experimented with the following change, and it appears to work=
 as
expected.  Can you confirm this issue and, if so, whether this is the
appropriate fix?

int poll(struct pollfd fds[], nfds_t nfds, int timeout)
{
...
    FD_ZERO(&readfds);
    FD_ZERO(&writefds);
    FD_ZERO(&exceptfds);

    for (i =3D 0; i < nfds; i++) {
        fds[i].revents =3D 0;                   //  <<< add this line to cl=
ear
the revents before they are set below
        if (fds[i].fd =3D=3D INVALID_SOCKET) {
            fds[i].revents =3D 0;               //  <<< assuming above is
correct, this line can be deleted
            continue;
        }

Thanks,
Jim

--=20
This electronic communication and the information and any files transmitted=
=20
with it, or attached to it, are confidential and are intended solely for=20
the use of the individual or entity to whom it is addressed and may contain=
=20
information that is confidential, legally privileged, protected by privacy=
=20
laws, or otherwise restricted from disclosure to anyone else. If you are=20
not the intended recipient or the person responsible for delivering the=20
e-mail to the intended recipient, you are hereby notified that any use,=20
copying, distributing, dissemination, forwarding, printing, or copying of=
=20
this e-mail is strictly prohibited. If you received this e-mail in error,=
=20
please return the e-mail to the sender, delete it from your computer, and=
=20
destroy any printed copy of it.

--0000000000009c487606326ed720
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
47klXeXRA8jF6gHnytRm1/P7BL8of6kmdCSk3otdAJ9k9pzz5tnWQioPWARaLVeMyk4t1XiuRihJ
rrAJSGQjHLJLT5O/W05xoD3mJsXj77hNZ8KKeYU9AgMBAAGjggHZMIIB1TAOBgNVHQ8BAf8EBAMC
BaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRwOi8vc2VjdXJlLmdsb2JhbHNp
Z24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcnQwQQYIKwYBBQUHMAGG
NWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwME0G
A1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxz
aWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRCMEAwPqA8oDqGOGh0dHA6Ly9j
cmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3JsMCMGA1UdEQQc
MBqBGGphbWVzLnJpenpvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNVHSME
GDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUIanzPNCEQ1pe7aEbypN58bK1L4Mw
DQYJKoZIhvcNAQELBQADggEBALUXyOyDRpJ5waCfGcgaQW6XfjRaI4xDe0W+JRyiYyXMN2rRVVpc
oy3OvoAXZJafUw/eS01/5axAVXVO4qg25ZwKApylNhTeeENodzWWsANAKuEteAxNzxvrbpD7Fkc4
Vga/X/F61SKguSv5jMFsUKtg/Ln88Rk7S7ITTo8B3O3gf/RzLBRVlJfd+FFUMOUZWQGze/uc1wI8
yPWWd2I0CzFSJ33MHhTgQ8+IKyKqYvHApwasLM78laZUnVUAjlAQBuHFc3nwEF7JDus5rT11lECU
LCdG3i6DG39k4hzuKlHEp75EdvQgE4JY5LRApU31g2DycFREGpXBJhU2sK15t9MxggJgMIICXAIB
ATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhH
bG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwkuajahPOqF3TaFNIwDQYJ
YIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIAeppB0eghpVdK3BbK1lwP7B+LBXdHvahgtE
rC0zOEt9MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDQxMDE2
MTE0NVowXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFl
AwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUA
BIIBAAdZB+RZgJIv9ZvqQlXeYWwYnXtNdxdrDa/gqIXQe1y3m9homP/eMlgfcNPPJsrVkILEqVsZ
FIDvYp6xjQeXU6WX209lk6yui0kCMwV0HPxTsvAW1N5/N6kbNtLhoeWA/HupBEdyQg+QS/feS89G
vkpZP3bEpK4tk861uCVwQaPkS2UB2IKZpCdDGRngI0sqU/CcfOCcH+toij5zFYaA81iggXkkeWPA
THyfK7VGhF3w7DTTyss4+tQVzlkQVVVkd17a+bH6MHTnst2ZgMmG7qM8hIVh3G7HvYAs6yj47VnG
q0EsU/xmD9cOUHptkTBVk3zg9d/cBe7mxQHwPBlJ4Io=
--0000000000009c487606326ed720--
