Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC25EC4332F
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 17:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbiDGRmp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 13:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiDGRmn (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 13:42:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFCF1F1602
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 10:40:43 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 237EqDfi009486
        for <fio@vger.kernel.org>; Thu, 7 Apr 2022 10:40:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=l38nfAmc5Ii8GUBCuiYDmlkftqxG8AA+boqZOLlgGEg=;
 b=XWuJQXMoi6ELOhpLubhVAxbs/XW/pQih5zyYrvPZKehHvf8M1oQC5m/+sSuO5wd+0R9e
 NCiCffDammmVS/oX9bsyE7Baa4de6RLOkNTZcf062deClQDQ90M9o0hzx765xBx86RA3
 vDtCS8yDfObK4JkzRViS1C0DAl45IbmPfnQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3f9gc38au3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 07 Apr 2022 10:40:42 -0700
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 10:40:41 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id C459720EC4088; Thu,  7 Apr 2022 10:40:33 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH v3 2/3] iolog: add iolog_write for version 3
Date:   Thu, 7 Apr 2022 10:40:30 -0700
Message-ID: <20220407174031.599117-3-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220407174031.599117-1-mogeb@fb.com>
References: <20220407174031.599117-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 6Nq2_aDxpxjD2JEYR6f-DIuRyc7yz2Wh
X-Proofpoint-ORIG-GUID: 6Nq2_aDxpxjD2JEYR6f-DIuRyc7yz2Wh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_03,2022-04-07_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Add timestamps to all actions for iolog version 3. Fio now generates iolo=
g
files using version 3 by default, and only supports writing using that
version. Reading iolog v2 still works as expected.

Signed-off-by: Mohamad Gebai <mogeb@fb.com>
---
 fio.h   |  1 +
 iolog.c | 15 ++++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fio.h b/fio.h
index 8830ff34..de7eca79 100644
--- a/fio.h
+++ b/fio.h
@@ -425,20 +425,21 @@ struct thread_data {
 	unsigned long io_hist_len;
=20
 	/*
 	 * For IO replaying
 	 */
 	struct flist_head io_log_list;
 	FILE *io_log_rfile;
 	unsigned int io_log_blktrace;
 	unsigned int io_log_blktrace_swap;
 	unsigned long long io_log_last_ttime;
+	struct timespec io_log_start_time;
 	unsigned int io_log_current;
 	unsigned int io_log_checkmark;
 	unsigned int io_log_highmark;
 	unsigned int io_log_version;
 	struct timespec io_log_highmark_time;
=20
 	/*
 	 * For tracking/handling discards
 	 */
 	struct flist_head trim_list;
diff --git a/iolog.c b/iolog.c
index f6023ee2..51aecd43 100644
--- a/iolog.c
+++ b/iolog.c
@@ -34,46 +34,54 @@ static const char iolog_ver2[] =3D "fio version 2 iol=
og";
 static const char iolog_ver3[] =3D "fio version 3 iolog";
=20
 void queue_io_piece(struct thread_data *td, struct io_piece *ipo)
 {
 	flist_add_tail(&ipo->list, &td->io_log_list);
 	td->total_io_size +=3D ipo->len;
 }
=20
 void log_io_u(const struct thread_data *td, const struct io_u *io_u)
 {
+	struct timespec now;
+
 	if (!td->o.write_iolog_file)
 		return;
=20
-	fprintf(td->iolog_f, "%s %s %llu %llu\n", io_u->file->file_name,
+	fio_gettime(&now, NULL);
+	fprintf(td->iolog_f, "%lu %s %s %llu %llu\n", utime_since_now(&td->io_l=
og_start_time),
+						io_u->file->file_name,
 						io_ddir_name(io_u->ddir),
 						io_u->offset, io_u->buflen);
+
 }
=20
 void log_file(struct thread_data *td, struct fio_file *f,
 	      enum file_log_act what)
 {
 	const char *act[] =3D { "add", "open", "close" };
+	struct timespec now;
=20
 	assert(what < 3);
=20
 	if (!td->o.write_iolog_file)
 		return;
=20
=20
 	/*
 	 * this happens on the pre-open/close done before the job starts
 	 */
 	if (!td->iolog_f)
 		return;
=20
-	fprintf(td->iolog_f, "%s %s\n", f->file_name, act[what]);
+	fio_gettime(&now, NULL);
+	fprintf(td->iolog_f, "%lu %s %s\n", utime_since_now(&td->io_log_start_t=
ime),
+						f->file_name, act[what]);
 }
=20
 static void iolog_delay(struct thread_data *td, unsigned long delay)
 {
 	uint64_t usec =3D utime_since_now(&td->last_issue);
 	unsigned long orig_delay =3D delay;
 	uint64_t this_delay;
 	struct timespec ts;
=20
 	if (delay < td->time_offset) {
@@ -731,25 +739,26 @@ static bool init_iolog_write(struct thread_data *td=
)
 		perror("fopen write iolog");
 		return false;
 	}
=20
 	/*
 	 * That's it for writing, setup a log buffer and we're done.
 	  */
 	td->iolog_f =3D f;
 	td->iolog_buf =3D malloc(8192);
 	setvbuf(f, td->iolog_buf, _IOFBF, 8192);
+	fio_gettime(&td->io_log_start_time, NULL);
=20
 	/*
 	 * write our version line
 	 */
-	if (fprintf(f, "%s\n", iolog_ver2) < 0) {
+	if (fprintf(f, "%s\n", iolog_ver3) < 0) {
 		perror("iolog init\n");
 		return false;
 	}
=20
 	/*
 	 * add all known files
 	 */
 	for_each_file(td, ff, i)
 		log_file(td, ff, FIO_LOG_ADD_FILE);
=20
--=20
2.30.2

