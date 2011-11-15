Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48684 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab1KOBtU convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 14 Nov 2011 20:49:20 -0500
Received: by ywt32 with SMTP id 32so2881774ywt.19
        for <fio@vger.kernel.org>; Mon, 14 Nov 2011 17:49:19 -0800 (PST)
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Mon, 14 Nov 2011 17:41:43 -0800
Message-ID: <CAAUT-yOwd16b1fCT+EZWyiKQFi7R6eHC0cSi3b8z6FNz6=Wptw@mail.gmail.com>
Subject: [PATCH] Fix parsing of ioengine strings
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This cleans up parsing of FIO_OPT_STR_STORE options which have defined
values (IE ioengine). =EF=BF=BDI made a few assumptions here...

1. If FIO_OPT_STR_STORE was used, that means a copy of the string is
desired, so it is always copied if the offset is non-zero.
2. If the values were the only allowed values, then FIO_OPT_STR would
have been used; therefore it is not an error to give a value not in
the list.
3. If an option callback is defined, then any values are ignored and
the callback is called to parse the string. =EF=BF=BD(Don't think this
currently applies, anywhere, but there is precendent in other options
skipping normal parsing if a callback is used.)
4. If no offsets are defined, and no callback is given, the behavior
is undefined - though this patch handles it cleanly and still calls
value callbacks; though I believe fio will still complain about a bad
options structure.

This fixes two cases (Restores it to previous behavior without
breaking new functionality).
1. External ioengines (The patch to a .so is never in the list of
possible values, so was never matching)
2. IO engines compiled in but not in the list in options.c

This patch should be applied to the 1.5x stable branch as well, though
it doesn't apply cleanly due to one line difference from my last
options patch.

diff --git a/parse.c b/parse.c
index 9a65e31..8aaf799 100644
--- a/parse.c
+++ b/parse.c
@@ -501,45 +501,54 @@ static int __handle_option(struct fio_option *o,
const char *ptr, void *data,
 	case FIO_OPT_STR_STORE: {
 		fio_opt_str_fn *fn =3D o->cb;

-		posval_sort(o, posval);
-
-		if ((o->roff1 || o->off1) && !o->posval[0].ival) {
-			vp =3D NULL;
-			goto match;
+		if (o->roff1 || o->off1) {
+			if (o->roff1)
+				cp =3D (char **) o->roff1;
+			else if (o->off1)
+				cp =3D td_var(data, o->off1);
+
+			*cp =3D strdup(ptr);
+		} else {
+			cp =3D NULL;
 		}

-		ret =3D 1;
-		for (i =3D 0; i < PARSE_MAX_VP; i++) {
-			vp =3D &posval[i];
-			if (!vp->ival || vp->ival[0] =3D=3D '\0')
-				continue;
-			all_skipped =3D 0;
-			if (!strncmp(vp->ival, ptr, opt_len(ptr))) {
-				char *rest;
+		if (fn)
+			ret =3D fn(data, ptr);
+		else if (o->posval[0].ival) {
+			posval_sort(o, posval);

-				ret =3D 0;
-				if (vp->cb)
-					fn =3D vp->cb;
-match:
-				if (o->roff1)
-					cp =3D (char **) o->roff1;
-				else
-					cp =3D td_var(data, o->off1);
-				*cp =3D strdup(ptr);
-				rest =3D strstr(*cp, ":");
-				if (rest) {
-					*rest =3D '\0';
-					ptr =3D rest + 1;
-				} else if (vp && vp->cb)
-					ptr =3D NULL;
-				break;
+			ret =3D 1;
+			for (i =3D 0; i < PARSE_MAX_VP; i++) {
+				vp =3D &posval[i];
+				if (!vp->ival || vp->ival[0] =3D=3D '\0')
+					continue;
+				all_skipped =3D 0;
+				if (!strncmp(vp->ival, ptr, opt_len(ptr))) {
+					char *rest;
+
+					ret =3D 0;
+					if (vp->cb)
+						fn =3D vp->cb;
+					rest =3D strstr(*cp ?: ptr, ":");
+					if (rest) {
+						if (*cp)
+							*rest =3D '\0';
+						ptr =3D rest + 1;
+					} else
+						ptr =3D NULL;
+					break;
+				}
 			}
 		}

-		if (ret && !all_skipped)
-			show_option_values(o);
-		else if (fn && ptr)
-			ret =3D fn(data, ptr);
+		if (!all_skipped) {
+			if (ret && !*cp)
+				show_option_values(o);
+			else if (ret && *cp)
+				ret =3D 0;
+			else if (fn && ptr)
+				ret =3D fn(data, ptr);
+		}

 		break;
 	}
