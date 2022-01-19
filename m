Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8BEC433EF
	for <fio@archiver.kernel.org>; Wed, 19 Jan 2022 21:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357336AbiASVTh (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 19 Jan 2022 16:19:37 -0500
Received: from mout.web.de ([212.227.15.3]:51313 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1357287AbiASVTh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 19 Jan 2022 16:19:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1642627175;
        bh=+TPqOFs6Yzogk8K4y/HXG6WS/YpU2bPKpcSZHbDh9vg=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=c8qPbrgDsOK4iaeKAjK6yebDmIVRmzKvkOoyNT/iVhbGRwrkAeCBqr9treMhS+ha1
         7DdgA2FgPMyv5U7MglUooiAd6zkl/baggqvAm4vwh8j6DTK0Q+d4JeF4obMDTTJmG6
         PhWFSy/AdWXcMz6cXZEcCqw7YC4A3NOT4zQmjBkQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from gecko.fritz.box ([88.130.61.24]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Mc1VL-1mawXF2paR-00d9af; Wed, 19
 Jan 2022 22:14:34 +0100
Date:   Wed, 19 Jan 2022 21:14:33 +0000
From:   Lukas Straub <lukasstraub2@web.de>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: [PATCH 6/8] blktrace.c: Don't sleep indefinitely if there is a
 wrong timestamp
Message-ID: <a19b7ea899093c4c0ed98d2d9a310f2f0f01fddd.1642626314.git.lukasstraub2@web.de>
In-Reply-To: <cover.1642626314.git.lukasstraub2@web.de>
References: <cover.1642626314.git.lukasstraub2@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/q6LXTocIHWPy2O27331=vDX";
 protocol="application/pgp-signature"; micalg=pgp-sha256
X-Provags-ID: V03:K1:Jpr0S7rxJdZibiiiS4j3JkcUpnk6V5uTUCYR71NSt1iAFuFfODl
 TWRpTKROts+7I+MZmhuIZm6DqHD3mULWPqe68r9h4IuOwEXBbS5rOtzHNAwkXzQUhubADMR
 fY+95rYhf9bQ0Y6+JJWRT6KrmW9M0RMtxaMB+/JDka166TqWZqd4py3Z/wJh7B8Wa92kBCG
 yUKaRPxqAMM/1hP0Y3/LA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:BwJlVgLzIgg=:fjensMYbdewD8owMYdvc84
 XmgsZsPZgEfZCCRJ2ytVY/2efs5G1+ckEecH/Y7z+YPw4q6siNxjmxccFLIBJap2xwvvQo/CI
 sDZOdqbtgWojEKHrojl1MsYYbg9H2em1uTtjlNEKlvlrON2npR9he8nb+oppjGuVCMAAkPLuA
 wQVsj6dTZdMlRezJgAd+4OSkTowyPcsxogBT+ejaCSHqQsO7sTH6ZMhDkKVby9OIYNES6a2u8
 l01LS9w5A5lKokhND6o/knJV273tUSZ0lv+R0mSzHGOE0kKI0MOGErz+JW2Y8oI6WagtfDEhn
 /ZwKieRwpkkkHPdCJpWgYQbyAbOL8df4zJduDe3x0fXRtLZwP03R+qK3W9P/D4Cfdk5PekWNa
 D5Adm1D5WGHFZBuKn5Q/jjPT1n3+jTBUETXuaKeNIDvyyuFoyxdWU7aVXTioukHSuiz8Gty99
 Tddz67oiC8wnZjFeIQNep0U/eheHBMCBxgpdBUmHW/66uwnOOE/SqhIjEq/hqPJRcJAnl36qP
 LkpK2HO4kbF46X40h/4kLQbkyq5s3xXK3tqCFaS0iqh5tbomo08nYiPmFIBger0vRmiwgYjJa
 9Z0SHtS8SKKIapZryWiUn3i2CRoEQgH307gPs6ei1IEgBknOChB6kWHCoyOlANwSvjMV388qk
 /KhRh2Oo8JMFmRe8nDU0RuQTxDH3vt8os3sSYPeTLaHzJs/ApslwEAMdbyNLBVCbjOBfAQfIn
 jwa6L2aLJtMgPgIZbsZ8BKpxhLmE4l1nw08vutUSwzV8j73pqweZjw8AacdJr8mYH/jdYtIbZ
 oxGHCPjj+asgeCQRxzM0PxiLVrIXhfz6cNcMvHcbWqfaLSbqHhs6JzxzDDU7SdyvW8jKnBh80
 aSFzCGBWHHh96n/xshkneiOZliFR98+JMqEpuTEidkqCj7CG7+bLuJuTa55ewu+edXaU3CEsw
 9/ZIfFZbLYVRttoQ3krYi4meG3oPQhJKJvtmJv+HUgpQPWcI51gFtR72I0wL2Xma3K4pV6JG4
 WohTxGHGh/AUUob0risLyB6ST+tuw3079lI6DD9/2YhuC4qhC23AMXtAZlW+dW7DMvqv50z/C
 t3pt29003YxoAo=
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

--Sig_/q6LXTocIHWPy2O27331=vDX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Each of my traces have a single entry with a wrong timestamp
that causes a underflow followed by a infinite sleep.

Fix this by checking for underflow.

Signed-off-by: Lukas Straub <lukasstraub2@web.de>
---
 blktrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/blktrace.c b/blktrace.c
index 7682a4d5..1faa83bf 100644
--- a/blktrace.c
+++ b/blktrace.c
@@ -307,7 +307,7 @@ static bool queue_trace(struct thread_data *td, struct =
blk_io_trace *t,
 		return false;
=20
 	if (!(t->action & BLK_TC_ACT(BLK_TC_NOTIFY))) {
-		if (!last_ttime || td->o.no_stall)
+		if (!last_ttime || td->o.no_stall || t->time < last_ttime)
 			delay =3D 0;
 		else if (td->o.replay_time_scale =3D=3D 100)
 			delay =3D t->time - last_ttime;
--=20
2.34.1


--Sig_/q6LXTocIHWPy2O27331=vDX
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEg/qxWKDZuPtyYo+kNasLKJxdslgFAmHofzkACgkQNasLKJxd
slj3ww/9G1r0WX4PRC0XDHGboU/GXONvxKKxjKdrsrHgQ7567UeW5HrUNOI93q15
MPYpIFpEmroI9dQSCGtUmsr6CwrT9bfXuc41xZgB5jgoyvHmrn4FSVH7ipcFQGLT
dZsuXGrOKwjniTNwzqARWDTE/R1w1oWFNlrciSJHBNGxP/7tpo4dNnuR4ldcgkR+
AyapejIXOhHDF1lyGua3pdNPivsMzzPhGeY2M3coMpzt5jrFdUm1as3LqMcaTFY4
fz9r9zOHn8hG/X0bJR93ayeiaxyShWBYXU4sov2iMMp/Mn7ufGZUypWnZyfta3zJ
1zFJBLCjshTK3hmzIb2V945wUnUQOuQE428REiksqXdZUKtrsN4/97E2eHoGB4nK
jvq0i4ny0EW1r07WnIIr4Ck0C/lFGV+/3KwLHi+Hwb7lRwPX7dRkiGUve8A9EnPz
patxx6uDe8btDhRJsYRQ7KzlVsKjbjSmZXBgeLEvmMSa3tn+nTPR+zEyqjk2XgFs
2ZBIX+tFJrZhLGU3NrT8d67uy+piqw1qn/JlEUgMpOY88AAb909KpJVr1nU6fkhW
1wGHANTlQHfejBYh0InE2ekwU2AgpvZRM8Vw1Qg7z5sCfdE/oVvS8YgCjOM52qSM
gXQfeAtU41Kbb3jv2HrZGvnl8Rsd5h86szWGPq1vzwIaDtWDoO4=
=DK0K
-----END PGP SIGNATURE-----

--Sig_/q6LXTocIHWPy2O27331=vDX--
