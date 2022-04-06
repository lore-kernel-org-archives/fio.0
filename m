Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B93FC433EF
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 18:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240443AbiDFSPv (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240263AbiDFSPh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 14:15:37 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60DCB843
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 10:05:46 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2366nokL016985
        for <fio@vger.kernel.org>; Wed, 6 Apr 2022 10:05:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1kt8+hl3VVdlAasDcOpwYPtN6bBIS5j0fw5yO9kBCRU=;
 b=rKrLYWWqwu17jK/WoP8OQ+6jBJtvtIr3RnB65uL/V+DlqXnEw/MHBVFLaLcQL1kI2C0f
 VwYJ3N271MjKE5M3BamTIulNPzOHAxZCqlQ8LFTjtXZMIguSWklq/VehSwQ1XEp20Tb5
 jPIdqc4//3AbUM93BIowyUc7y9vW5qaVVGk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f8trxqpkv-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 10:05:45 -0700
Received: from twshared10896.25.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 6 Apr 2022 10:05:44 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id 5626720D98DB3; Wed,  6 Apr 2022 10:05:33 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH 2/3] iolog: add iolog_write for version 3
Date:   Wed, 6 Apr 2022 10:05:29 -0700
Message-ID: <20220406170530.2198263-3-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220406170530.2198263-1-mogeb@fb.com>
References: <20220406170530.2198263-1-mogeb@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: JPpiVtv72KRxVfqwH7kVom0blnR8znIn
X-Proofpoint-ORIG-GUID: JPpiVtv72KRxVfqwH7kVom0blnR8znIn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_09,2022-04-06_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

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
index be7eb007..b7ab08be 100644
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
@@ -734,25 +742,26 @@ static bool init_iolog_write(struct thread_data *td=
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

