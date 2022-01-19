Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16EFAC433EF
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245220AbiASVOQ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:14:16 -0500
Received: from mout.web.de ([212.227.15.4]:33179 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229564AbiASVOP (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:14:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642626853;
        bh=ZKAvlaMlVybRp1/mf55pq+dXbg6OVwcpuHtBpG77eQg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=TzX/QEuEkTQxnFjz8vyCnYATxfJZXTJ1QpE1D3gQY8W1tjnA6v1vh/eaxi/b9aZXz
         m5/34MdmXx4u2VOINgPJi9/ReVa8Q51ORgpclAXQ2l6uawrs/qpH2BLrHSBjBay1/j
         NvsG2RzxESxs9cq/PEN/pfdIAjNkIu6sNNuEVXdY=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M1JB0-1n8dKB2LRy-00368P; Wed, 19
 Jan 2022 22:14:13 +0100
Date:   Wed, 19 Jan 2022 21:14:04 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 0/8] blktrace: Add support for read_iolog_chunked and fixes
Message-ID: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/yOVvGzZZ0O+xTHBIt39upLz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:peMPwnFtSsgYQJTnhq/uEAnDV6Lcs9KVNpoywKy6cB1s5cuKP2e
 nnazY3HpFXU2VyOxHYwdo3MJy83GsBzTP4VYMKDTRBW+4q5UaQYN7+TxSX60whyjCeW2dke
 6uUfVTVEAGnKskPDLEbTZ1OleEggtDCOwgH20nxcO7AsTlQPrxbJQEg2kypAImXew4bP3Gn
 /LJci54bYgn4Ep431RCAw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:URQlrorlVHo=:mIhStDl12aH81rp9vjBguq
 nEaD+hBJcg6ytjFh+tuvblXwxihKGB7BihvMvgKnjEPcs1le+86xQ7PnmLcLRJqv/wh860h26
 D6dsDs7D0mqSiJ+K0mjc0WzFo83uauNfvwDlqQOQ0DqoOSsvVSorp5HtkyBDOIwKoYczIsyRB
 rk40c4vdzKXbagn4HhJ2PVUNe4AJuK9qf7ulX4Xs1J3AjXlQkiM8o9L79lrLvU+QYntX+kKHP
 CaUHs/ng20mHHsQ2UMMflEt314g25uLun8jSF2H0Kp694z2TO7TBNFA63dZqf0TWBkvW1eFfM
 gwPioVXfe8Z7XCtRo/ltjV78EF6r9eqJp0+VMZIjVvJiDVOOhKtPZubCo+sMmpOLL6e/2vyHS
 eZBdxv43If1h2XZbS5nIj2H83O4KhY+XAGAO1eO8URT0onCnokPPteK3PV1HOAJLjIAbWpIR0
 Ew6hDGvtXnXNyBDwN9jv4EyJDWD78XlYsvvc8Qev0OUrnaOg2NmsHHjeRbFDFSNiKBxvBnrO4
 0+aYiJydOlOFt0aYRwVO3yoYv5VT5ZZ6eiU3xgsG2vVqZiz+wBBsGXxId0af6u6wbD/0s9CVq
 sJlRi2dHdFsQnFT6T0zu6uud17u4+3CM8zVwA5ykwWIWzquwljKJViYHxYArncNJ2LVeBS1y4
 mYrJ1FfF+M1+4takeuo3M7Jq6udMu57QEqQqVc9QuIHqjMlLXoN5Hv7aEx76KgGvzxgssTYRe
 xo7YPMr1K/Ii58lBbucBtMqLWGlaSIYANSWGHcbXKUuz16n3MZnCtYf8aV6KGmIh0FMxUv7Z6
 GcYT5tj7y9v0EmsOWSdGXYf0Au1fYEF2RG1WtPKfslxouFo9aPvqTI/ECRT0P+efkV6thT6P9
 DEmFc2Xh55x+Ht8yC6vj5nnDj43Z2w5Ve6M/2EOz6HeU4DWc7ItQsyt3TRXb/tafLdJjc2xXd
 N6n7P1tst4PmJZ1CnQCw6uos67dfeh87d72klvzznujGQYvG86CP/rnHKp/H9zFCHXyWccGPk
 gsOLEdWOROrZpjThFRnqZHqxwVBVqaqr4Ygr7JObV3zmQF2besVrufRlYWg+dle5Z8eUFJBG+
 H2T0WG77LHMggw=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/yOVvGzZZ0O+xTHBIt39upLz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello Everyone,
This series adds support for read_iolog_chunked to blktrace and fixes some =
bugs
along the way.

Regards,
Lukas Straub

Lukas Straub (8):
  blktrace.c: Use file stream interface instead of fifo
  iolog.c: Make iolog_items_to_fetch public
  blktrace.c: Add support for read_iolog_chunked
  linux-dev-lookup.c: Put the check for replay_redirect in the beginning
  blktrace.c: Don't hardcode direct-io
  blktrace.c: Don't sleep indefinitely if there is a wrong timestamp
  blktrace.c: Make thread-safe by removing local static variables
  iolog.c: Fix memory leak for blkparse case

 blktrace.c               | 325 ++++++++++++++++++++-------------------
 blktrace.h               |  14 +-
 fio.h                    |   2 +
 iolog.c                  |  18 ++-
 iolog.h                  |   1 +
 oslib/linux-dev-lookup.c |  21 ++-
 6 files changed, 203 insertions(+), 178 deletions(-)

--=20
2.34.1

--Sig_/yOVvGzZZ0O+xTHBIt39upLz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofxwACgkQNasLKJxd
slgbKA//QW3I8Y6XKWWFj3+IXPlcMvJQjz7ewffdlMo8b5UFXdSZNnJxr5c8l5tu
CtbHt6I1LwJqeKKrBE4i+H9Ez/OFRZk+gGz9iPWYS5gALlqPcDVarPmlRsypVjNZ
YLXF+l4sT/afS2UqKIhD80H/lM/jtkSNmsxV1yPMRfHehod+8oggpYMWzr8obYeQ
bdQjczJu7yei8vY+I1ZA8S5jJqG1N5Irci8ouZgMJUOrF/4XsWsNc6ABwxm50aiE
ez+AaqzldQJrELdXKyoDeR509g6+EcNGXw2z1RdwqmgeF3olCdBwkxoedlwSVEI5
uqBwAIiK7Ima+m3XTgy+KmnE2Uyf6QegpoJYpo5sbQqUFE59M6wPjd8RPnUUUYl2
LLAVEy2scSB97qfBoN+T9ZO+u8qO1LB6gClKGsracc1S2L3Vyt2e4AtO9cuynLM3
PbMTT0cR/00DHP+nJQTo7YxUt7pTlu6oNBwvzIfHidDOVCitU4oc6btIRSkb3Kap
ihKyQcPq0q6mXDM7mSof1yLw+WWGHmxchJ99wSR8mfxzny2gFzlra5wl60/jK3o2
DSU+jwW2IvVxsJKvw3Fb9F9/Ur1k5XR4GE6575llFNLRLuQN7+YBEspMzj6+Fqkn
DShHh9op3Zmat1cug/lZ8AJDpXTWMTjjMMGwZ1QoKTbhf4Lq8xk=
=lscO
-----END PGP SIGNATURE-----

--Sig_/yOVvGzZZ0O+xTHBIt39upLz--
