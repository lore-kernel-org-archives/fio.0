Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:46348 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887Ab0LOB2e (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 14 Dec 2010 20:28:34 -0500
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 0234EE83D1
	for <fio@vger.kernel.org>; Wed, 15 Dec 2010 01:20:14 +0000 (GMT)
Received: from unknown (client-86-29-47-22.glfd.adsl.virginmedia.com [86.29.47.22])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id CA075E83D0
	for <fio@vger.kernel.org>; Wed, 15 Dec 2010 01:20:13 +0000 (GMT)
Date: Wed, 15 Dec 2010 01:19:40 +0000
From: Bruce Cran <bruce@cran.org.uk>
Subject: [patch] FreeBSD build broken due to missing -lrt
Message-ID: <20101215011940.00001c21@unknown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/H+4R.hTPGUqRjID4JwJLJgB"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

--MP_/H+4R.hTPGUqRjID4JwJLJgB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

The latest fio fails to link on FreeBSD because timer_create is in
librt but the -lrt flag is missing from Makefile.FreeBSD.

I also noticed a couple of compiler warnings when building with clang -
a format of "%Lu" is used but 'L' doesn't have any effect with 'u' - I
guess %llu is needed since the types are 'unsigned long long'?

I've attached patches against git HEAD.

-- 
Bruce Cran
--MP_/H+4R.hTPGUqRjID4JwJLJgB
Content-Type: application/octet-stream; name=Makefile.FreeBSD.diff
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=Makefile.FreeBSD.diff

diff --git a/Makefile.FreeBSD b/Makefile.FreeBSD
index e4adfca..9378b19 100644
--- a/Makefile.FreeBSD
+++ b/Makefile.FreeBSD
@@ -52,7 +52,7 @@ mandir =3D $(prefix)/man
 %.o: %.c
 	$(QUIET_CC)$(CC) -o $*.o -c $(CFLAGS) $<
 fio: $(OBJS)
-	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(EXTLIBS) -lpthread -lm
+	$(QUIET_CC)$(CC) $(CFLAGS) -o $@ $(filter %.o,$^) $(EXTLIBS) -lpthread -l=
m -lrt
=20
 depend:
 	$(QUIET_DEP)$(CC) -MM $(ALL_CFLAGS) $(SOURCE) 1> .depend

--MP_/H+4R.hTPGUqRjID4JwJLJgB
Content-Type: application/octet-stream; name=filesetup.c.diff
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=filesetup.c.diff

diff --git a/filesetup.c b/filesetup.c
index ae893c7..bb36234 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -316,7 +316,7 @@ static int get_file_size(struct thread_data *td, struct=
 fio_file *f)
 		return ret;
=20
 	if (f->file_offset > f->real_file_size) {
-		log_err("%s: offset extends end (%Lu > %Lu)\n", td->o.name,
+		log_err("%s: offset extends end (%llu > %llu)\n", td->o.name,
 					f->file_offset, f->real_file_size);
 		return 1;
 	}
@@ -734,7 +734,7 @@ int setup_files(struct thread_data *td)
 		temp_stall_ts =3D 1;
 		if (!terse_output)
 			log_info("%s: Laying out IO file(s) (%u file(s) /"
-				 " %LuMB)\n", td->o.name, need_extend,
+				 " %lluMB)\n", td->o.name, need_extend,
 					extend_size >> 20);
=20
 		for_each_file(td, f, i) {

--MP_/H+4R.hTPGUqRjID4JwJLJgB--
--:
To unsubscribe from this list: send the line "unsubscribe fio" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html


