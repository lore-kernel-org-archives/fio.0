Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8840C433F5
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbiASVOX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:14:23 -0500
Received: from mout.web.de ([212.227.15.4]:50513 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbiASVOW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:14:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642626861;
        bh=eXiQHLmodAY0ZfOw+H0CxeLgwNzTwq6oM745kkwl+pY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=ePWea7g/5lxkk0uEyIDvAWsSN7ugSaQIdxPE8J4JwYY6G7HKk7iIBFCZWZaTg7AXY
         Md3AI36w2dl7xEHd0xiF2rEYXp5yl+vqhZU2/FAwLxZKCU6npMB4zDt47/oG7Kw9rW
         JtVucS9Vkqba5M+qFDz/dQ5UedJqmdEEupjsL5ng=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M1JB0-1n8dK246Cg-0036Hs; Wed, 19
 Jan 2022 22:14:21 +0100
Date:   Wed, 19 Jan 2022 21:14:20 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 2/8] iolog.c: Make iolog_items_to_fetch public
Message-ID: <81c9fbb31bbf0c487dc0ebff5eb85ca764fb14ef.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/I0=Kk7A4yz8LOZfYZQ4C_.H";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:AgC6NncmXMvTyYBBXkygUNt39fZw4cHI7IKB9eM7UBiByYgHODb
 5Fwx//MTQqJ+aIiEPP4v2qZtYYCDrO0+QcCyjU6PvzM0Fp920cwWQ0AFwh5UcHg8VQnP8hL
 e24CG7rICiL7yLAyWNvskgnhKyfF9rB2cQDtJMZ++2+8qYl6e27/c44SlrqBHuZCjiFkS+R
 LTfbgxgyqpwY4WTsHRLag==
X-UI-Out-Filterresults: notjunk:1;V03:K0:amTIqceGYLc=:QTJ/GL5OucqGQL2v9ukjvW
 u9tnSb8PKSDfThcbXPL7TpeJKUY8lkt/y7hGFzYWfci4Fhm8AzioWk2ZcLWthbPKMyDyk66Nk
 HdTY+X6B26S7VZ8cMle4E7dPrh5l4vZKX2sAB2wLvdlT0vWfbvGSi2i5Du3T0wiZA7zbDfWQW
 lGk499HhZ7ceLNI/g6Dt6ff4zf3NhxPXE2YogLwzeR0BG7XbwpipdfvFJQPxmL0otTzubn9IA
 pjc/4zhGiO2culbkZMX64NfBvIjuLv5RfM/fjyahRWbwgHA3pz2HVrCcfEvQDny5hGLF1CPEe
 E5gMdVb0Uq23C6a7G6Wro49GDdUth1KhGH4S3r2qa9jEsy4Fn00PLIl3T1QaatAGGqKhm75Cw
 4XgvVDEo1UwA87ZhAdLifjzjILJ3USZXVERNKq/Q09FVYBNRITgK+CpZZBgcftazGsFWa72io
 3cBNT3zaaB/AzDLB2DdaAK8KMMi+l5PHgE0xRNolHD36A27csg4ATo85YSkG9XcidLt5xA1l/
 qtyuxUCAl+XRrEE8tkn4oioZ1V11Hw2Yl9Mmzimo5KRVM+A8Ethmp6b+LERzFrYFxnWfBHKj/
 muAB5xwRbW/BcXrkSSUPT+pjmz4YA5cfidDE4vXIrHMd35j6EGVgWwWp4SDl4rPa+InaGR+9h
 N+QMvY329nOnogg8k07w/k8nyMI+vXKMfsbAaXdVa31ryf3rPcu29l1vG4MHG1j9DYMcdGR7Z
 KC02bHGQPaQo40rM3V7CY50QqjQH6HX2GESH3AqUmNsM7UJbFbNFIMXrt8lf+54gu5vXnZ24r
 wt57cL6omixjCrZHw58+dXbHGjKbnAmDSxb7N5jWk3eF5+cfXuDTHmhTxwDAQS9u5aaJ4azN0
 D7ThjI5lcD/vde9N5MSlONYLK/7HKtA/puATRyz7pbrJ4W+qrVy1VoT5eIFk93OQ9UYCuFX4p
 r5F4ei/PXRwVJ3fDeil/fmwGKZI2e0TPuNVPCoVn3qHkTkr1MBaAOAjnXP3NLIRdKwwU9qOT2
 Si09ZFbRbjeYNDZ+VIAizXA3K6DcIFF6s9NXzKo30mvGby9pC2ozS0FwfNqV8jhJHrf73J+rg
 ZQezs5aNKabINo=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/I0=Kk7A4yz8LOZfYZQ4C_.H
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

This function be needed in the next patch.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 iolog.c | 2 +-
 iolog.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/iolog.c b/iolog.c
index 1aeb7a76..3d4646a8 100644
--- a/iolog.c
+++ b/iolog.c
@@ -355,7 +355,7 @@ void write_iolog_close(struct thread_data *td)
 	td->iolog_buf =3D NULL;
 }
=20
-static int64_t iolog_items_to_fetch(struct thread_data *td)
+int64_t iolog_items_to_fetch(struct thread_data *td)
 {
 	struct timespec now;
 	uint64_t elapsed;
diff --git a/iolog.h b/iolog.h
index 7d66b7c4..a3986309 100644
--- a/iolog.h
+++ b/iolog.h
@@ -254,6 +254,7 @@ extern void trim_io_piece(const struct io_u *);
 extern void queue_io_piece(struct thread_data *, struct io_piece *);
 extern void prune_io_piece_log(struct thread_data *);
 extern void write_iolog_close(struct thread_data *);
+int64_t iolog_items_to_fetch(struct thread_data *td);
 extern int iolog_compress_init(struct thread_data *, struct sk_out *);
 extern void iolog_compress_exit(struct thread_data *);
 extern size_t log_chunk_sizes(struct io_log *);
--=20
2.34.1


--Sig_/I0=Kk7A4yz8LOZfYZQ4C_.H
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofywACgkQNasLKJxd
slgVRw//WJDrfPqpoOjHTW0cI8tgctYigbGG9dJd1tg1uidLiXW/Yy79EgMlWyLa
Ir/m4ErTgMYEn4xA8PDD9kGZyd/8GtVzC7efMKfZm9taWsylx58rQMCpTfWHYbxK
cmldBTwN7Y3SH8LquDQ0suOw85kZVvOxxKNoT/R42YV4ZECHEyDSubbBQbzFpd88
xJ90OyWkqLramTU3QOVd4rgicML1UrIWaF9sfGNN8eJYmVFavE24Zl/IQsvxGsSL
Ri57biEHx0fIfOeT14Pza8Lazg6NWqBawoiTxntfaY8AmifCnketXdC3ZGgFR3c3
HH1siGgXvknnPkoXHHUNWORCSLQxdZWd0eLg6uCio3Plz93taw8e0eR2wHFpXxXD
xqbxfWM0GdhshvLicFUwu8gtW68ICxZK2z/Eqq/4jxPhh4LIeecJ7aMXWEOWplv7
fkf7c+YliJhQeod+Pk2HzwWonKju8IMzsNpV9WbMj4SHo4zqLNhLFv30WItKAmHw
6oXyRZ5M+dS5K59bKtWhxV9laszv87UD/y1khxO7qusfblqLdyDa1CzmoVqno4bz
g4VFJTolxpeXpRgpCDqdiMcXmcYxuzGoUSfInkfJiUUBL60Sg7wWADDUAJDRJ4la
AnzJbBdJTVrHuPRzhnofMTUOfZrbxP1sDObH/KB56pgHDNUiEu8=
=D0N6
-----END PGP SIGNATURE-----

--Sig_/I0=Kk7A4yz8LOZfYZQ4C_.H--
