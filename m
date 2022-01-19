Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BAD8C433F5
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357384AbiASVOh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:14:37 -0500
Received: from mout.web.de ([212.227.15.4]:53249 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245720AbiASVOd (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:14:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642626868;
        bh=MALVCip3GpOUTtkIJ7OQebbkFuRmLivc8CZ7eNcq8m4=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=nZjxrg337fDE4rZ8KQ0i5k8SysKUzNySoIOM+RTbB5GCHD0AFzvEllEbMKnKHUlf+
         GgNd85VwDYI8an3WVe7Zmqly2C2JncudvzrVH1xFivcHuDdQ/qvW40wZbzqeD59Nnp
         7GrcaS5IVkGGLDb14LaXR3z9sa1F/A1vjz3wCfVQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MpCmZ-1mWUXs3qOt-00qKtK; Wed, 19
 Jan 2022 22:14:28 +0100
Date:   Wed, 19 Jan 2022 21:14:26 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 4/8] linux-dev-lookup.c: Put the check for replay_redirect
 in the beginning
Message-ID: <0dd4b6407f7b7f5f15f1fcad409554ff339ffca1.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/TjpDzeh9PMMI4P8=UpUfcy0";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:yIqaurHP87m5JwmZ02HJ2bypK4UOb4rEv53nM6gO9UgBacZ26sV
 JAQ8tl7PsqFIz/YHEfSpET5AYNRmKRvI4CeHOVHkrh92MDliH5zXqPgPRGnozAwzxSwcdx8
 btydy8UEjjWQVNJ2K7y8rpphgKeSrjzMrAYf62tI78RKO4WLxe9ftNs4iaSiWOOL/UbqJni
 Z1H24PCX3YDHeghr06WLw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:daiif/SVkQ4=:mJE8zghXShn4KbNLuHjwAy
 NNiEtKZiW3TYf2OdivQx47a9hPysyr2ZnMx6INHQN1cli0Hz/CKP37E5dSdN3uXF6jQje0biB
 oPoFXtFCd9dUXok+wlzjEjQZHth/ky00yKZlWrr0A6aANTaHwCZBiN+FsLUqLVw9SFZTMk8i+
 lyxUpYjacfSiVkeO3H+LshpAeAefKBkYKiieezfSI1e2sYgOIL7O+mkSUKB5sn7buFgHHe6LL
 NTrC6zhOT70NNXGQQxLgdq6X+pj+qIMyBKZDPcNw9BzILYDhxVW9d9GwyBf7KnIFLNi+Vw58n
 4vdDPoHLP2OSJCBYDOldJAqgPO2/Dfnyr6O63GLVOwM8kC7jCldLK8Z4woZZQW2pVMNIIE2wf
 U48etg1JSW9csYLe647fd8HvmM0xi/AkAWn0Xs9aA0oHpryf+CMxQKmNgKFgnMWkv1duNUQdG
 aBAJdFB92WxiSf3Gv0EW7kBhdNmw5f6tVLuydx6hKW4rUPpeVUD6tQ0ZtBpeABuwAT0lMs90D
 yJdaHKahNJZCvlVblGj0BM3MO6MbmsOq+aZYw9Htd+9UTbDXnK3romzVHK2O1FnupkmrPMwNc
 dkiyQwmUP6zp06lEbhRDiVbI6/GINzV6Xuh6ZbnAeYzyKaIsPsvMlxDo6tbE4hqgqyb8d5e5Q
 VA18ypFTcID9HoAWWZj7YejPODa3ZY9E1pHxGqjorZyehzvKVW1JU+96nraFYj+Bs2BxatboM
 f4hyfRlFDPhM/9ExThfV79KMXehHlhQeUSGlYhlYrbAlJiov/oASKBj9hTNcV3SWgL8U6wRxq
 JKjeBjzXfC6udKQPv7Wvr/2DiK7Mqn9brxfJkbN67unNh58WksafeX4KUxpgmc1s177o7dxtc
 Red32WbR85FwwuoWmZVT5VQ4KJdrVPrK3LXTudWvWvVRK/2Ez469hTJXvUUqZUps03NCSvkgT
 TYUh8Zd8fFJPeGOM2V4v/PQgR6evSm0TJLStCfip7Za69eab2TS4PSoE7ZaETheIY86X4mbmh
 MliDdeznTjl140O2mOMB9mxMxziq24ts2Ac8dz8VN2DaxPHI5NQ5er6rMgt2jXLd/4LOrri70
 conQd9C02+arqE=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/TjpDzeh9PMMI4P8=UpUfcy0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The machine may not have any block device nodes (like my dev container)
which makes this function fail despite replay_redirect being set.

Move the check to the beginning to fix this.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 oslib/linux-dev-lookup.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/oslib/linux-dev-lookup.c b/oslib/linux-dev-lookup.c
index 1dda93f2..4335faf9 100644
--- a/oslib/linux-dev-lookup.c
+++ b/oslib/linux-dev-lookup.c
@@ -16,6 +16,16 @@ int blktrace_lookup_device(const char *redirect, char *p=
ath, unsigned int maj,
 	int found =3D 0;
 	DIR *D;
=20
+	/*
+	 * If replay_redirect is set then always return this device
+	 * upon lookup which overrides the device lookup based on
+	 * major minor in the actual blktrace
+	 */
+	if (redirect) {
+		strcpy(path, redirect);
+		return 1;
+	}
+
 	D =3D opendir(path);
 	if (!D)
 		return 0;
@@ -44,17 +54,6 @@ int blktrace_lookup_device(const char *redirect, char *p=
ath, unsigned int maj,
 		if (!S_ISBLK(st.st_mode))
 			continue;
=20
-		/*
-		 * If replay_redirect is set then always return this device
-		 * upon lookup which overrides the device lookup based on
-		 * major minor in the actual blktrace
-		 */
-		if (redirect) {
-			strcpy(path, redirect);
-			found =3D 1;
-			break;
-		}
-
 		if (maj =3D=3D major(st.st_rdev) && min =3D=3D minor(st.st_rdev)) {
 			strcpy(path, full_path);
 			found =3D 1;
--=20
2.34.1


--Sig_/TjpDzeh9PMMI4P8=UpUfcy0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofzIACgkQNasLKJxd
slhTbBAAioPw2LtPq8YgBVPcRt9heeRZKX7UNOCPhuaIF1pr/ThoSvYr2rHGx/0V
d9g1mElVaGaUvY6MfWjwDOXAY4b+3E6KzGlXV8HrW51XgWR9MsHelEYRnSodC8Au
B9rFXBAyyq8p51QHPx3Ba+xjcv1OpPum/e4DKEhs9TngsSnHlohUyqKavJOQon/4
rYw2ck2mZQixvAd3CzgCfEkBeEH8/AYvT6trwIQ8oAUlM5X5CmFJT0r7Dp59pMBD
ZoUNmpZ4TYrIrqMTkugZBBZnnYpbGzjyux17vEZ0zimSMHgIFG11dcTW+/y5YLXH
/JFBZaB5RGwbPnKF1ZoDyf7ZdcB2OzR77KMxzVXHVPpXu+/4UROjByZJ8E3aWCL5
xo/tR8meMfj/wgwJsEJ0nw4VwCxotNE/04uFdIlkRs5Ub1dLIzod0p6OKi+5KRK1
dB9gJkBd3iMG4F2jziHEsRq9Osmd8xRmQy/LqadW8hoHnclnVAJ3IyjhzsKA4mgP
cI5B20hUjyeWtgELUcSJrDWEKqbeLJWu0HJDVkyJF4fEsgpLwXpmfr8rBpinSvqk
6JeRK4f0RqdTHTF3TCVJ3K1EDBsAF2ckQMfJmdA7CiGeh8YKHt995swOBPR47Y70
l7O7+CdcLnpYDEYWKSxlX87fHcFmMpkZmHERP8ibKBOc1u+9Dzs=
=BrXj
-----END PGP SIGNATURE-----

--Sig_/TjpDzeh9PMMI4P8=UpUfcy0--
