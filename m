Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF741E50D
	for <fio@vger.kernel.org>; Thu, 26 Sep 2024 00:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727311323; cv=none; b=KvgP6ieWon0liknPkM5h5uQomyYj/yCMsxbxXWCImiGhuZum7NFGCX6vwfigfFTM4vA7jtzSPs8xgJ/Ov+9H5/8QiaYcHhsrOfxZVa2MsaANrlXWt2VZGNDYWb169WBmoKTomrSUg8lmZu3PfNeSAsNlzbHJMFwCm9tF5w1CpzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727311323; c=relaxed/simple;
	bh=D17ZNtaZaQggnPnIexeeY88UIT5L4OpJ8SBCkZ+zmUU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kfxi5M4FCKQIaRQbddeljTpggDK+Io46srdh3uFKwRvsjeuimmif/dqUEP0XKeC7BojjXC0H4ozzZIr8euUbgLBQDM/ZCChQbxm9TnfN9CiOYAym9SpcaI1FeuPyFXz1jzoUxG1Ziav2lhoB8mdjUNVhmF9oX4bOjg2XqZwZmOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BxqdJnyU; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BxqdJnyU"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-718ebb01fd2so77181b3a.2
        for <fio@vger.kernel.org>; Wed, 25 Sep 2024 17:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727311321; x=1727916121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=czfICXIRrXTkvDUHQc7yz+QZwv5GpfpuJgix6Q8uhhU=;
        b=BxqdJnyU0eIjU545HDdzo3qe6X240IgL069t7QrcRAC781lYrePEiyIh1cNhrUFTNQ
         I1fCWSAhOw+v8hfO27h/oMu3ArxExdiNSIoQRQkZfTIdgp3iAECaPp9SZVD04IQ3NTCk
         4bB3jJZQgW4jXxxsPKlUphIG5vPsgYE7Dt6Gxr5A79v0W18Eb4lBJzxYR8itAWzPYScG
         bnn11xcj9WnpWkBW9+u6B2ibvUe3/z6fpQcWEAlOs9dS2Ru248wukeaDE8WVXuMwEwPl
         DjGrj9430K2RC8WUjohgveYrKqx23EP3mnRgfWuqHgP2K3D/uLbiu1ulxvLPode1PLGL
         TxxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727311321; x=1727916121;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=czfICXIRrXTkvDUHQc7yz+QZwv5GpfpuJgix6Q8uhhU=;
        b=jsPWc24UE98U9BBMpX1pKG5qQzkYES2qVifzQHuyjIT8o07Vma8fLCJuU/lNNs132a
         xlVM3Kyc3rIYGw6WSi7gD+Y5g28tN9Cu6oxHFA/T3ISirrTjOQF6beS//n68f++Lgjzq
         NEZpEBSTP2r7h5gjWnruIkQMrXV0OPXtaTCTSh9Wmh2/U/yH2LTRJSfmeOIobMYL0pYL
         PFVofco21gVSX5iq80NZDEjHo4kJGghxeJfy38/F1+4VJDxmjYZZAmSDVAke1CAzEWcf
         /L/tsF5XHwqe0wt8rdCpsCyHe/0Oi7XvxWa9AagdphfbhFkRGpldCaojIDJVAkpJwdJM
         T7uA==
X-Gm-Message-State: AOJu0Yy0PBE878Yl4OiB+g18YwIfEoj3LKG1+JmBh6HnHtKwNqz8xWVC
	BDXeIBs5ApERf88/0aQqlvrNFKYhQsRvTZQ6tB7BdsEmEPPXWMPkaC6sUA==
X-Google-Smtp-Source: AGHT+IENkNgxRoSRWJH1lkxcIxlKLWJZSm37jkoE+SwkX+sgRwvrAHEivmgU0odwnT3Ea2p1WFovXA==
X-Received: by 2002:a05:6a00:3e17:b0:70d:140c:7369 with SMTP id d2e1a72fcca58-71b1a625668mr610485b3a.3.1727311320540;
        Wed, 25 Sep 2024 17:42:00 -0700 (PDT)
Received: from localhost ([116.121.76.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc9c79b0sm3251116b3a.205.2024.09.25.17.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 17:42:00 -0700 (PDT)
From: Minwoo Im <minwoo.im.dev@gmail.com>
To: fio@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Vincent Fu <vincent.fu@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Minwoo Im <minwoo.im.dev@gmail.com>
Subject: [PATCH] io_uring: Add IO_U_F_DEVICE_ERROR to identify error types
Date: Thu, 26 Sep 2024 09:41:34 +0900
Message-Id: <20240926004134.26004-1-minwoo.im.dev@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__io_u_log_error expects a positive value of io_u->error parsing it with
strerror() expecting it to be an errno.  io_uring_cmd (cmd_type=nvme),
for example, has returned errno value as a positive value and
device-specific CQE status type and code as well.

Commit 78831c6b35c5 ("io_uring: Fix the flip to negative of CQE status")
has put the abs() to the cqe->res, and it caused confusions between the
actual CQE stauts and the system error value (errno).  Now we have
Commit 2a13699a89dc ("io_uring: Add .errdetails to parse CQ status"),
meaning that io_uring_cmd ioengines will parse the actual value of
io_u->error value as CQE status value, so we should know if the value is
for CQE status or errno.

This patch added a flag IO_U_F_DEVICE_ERROR to io_u to represent if
io_u->error has device-specific error value, otherwise it's errno.

Signed-off-by: Minwoo Im <minwoo.im.dev@gmail.com>
---
 engines/io_uring.c | 22 ++++++++++++++++------
 io_u.c             |  9 ++++++---
 io_u.h             |  1 +
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/engines/io_uring.c b/engines/io_uring.c
index 96a042a88820..1ab9a1765e38 100644
--- a/engines/io_uring.c
+++ b/engines/io_uring.c
@@ -528,12 +528,9 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 	cqe = &ld->cq_ring.cqes[index];
 	io_u = (struct io_u *) (uintptr_t) cqe->user_data;
 
-	if (cqe->res != 0) {
-		io_u->error = abs(cqe->res);
-		return io_u;
-	} else {
-		io_u->error = 0;
-	}
+	io_u->error = cqe->res;
+	if (io_u->error != 0)
+		goto ret;
 
 	if (o->cmd_type == FIO_URING_CMD_NVME) {
 		data = FILE_ENG_DATA(io_u->file);
@@ -544,6 +541,16 @@ static struct io_u *fio_ioring_cmd_event(struct thread_data *td, int event)
 		}
 	}
 
+ret:
+	/*
+	 * If IO_U_F_DEVICE_ERROR is not set, io_u->error will be parsed as an
+	 * errno, otherwise device-specific error value (status value in CQE).
+	 */
+	if ((int)io_u->error > 0)
+		io_u_set(td, io_u, IO_U_F_DEVICE_ERROR);
+	else
+		io_u_clear(td, io_u, IO_U_F_DEVICE_ERROR);
+	io_u->error = abs(io_u->error);
 	return io_u;
 }
 
@@ -557,6 +564,9 @@ static char *fio_ioring_cmd_errdetails(struct thread_data *td,
 #define MAXMSGCHUNK 128
 	char *msg, msgchunk[MAXMSGCHUNK];
 
+	if (!(io_u->flags & IO_U_F_DEVICE_ERROR))
+		return NULL;
+
 	msg = calloc(1, MAXERRDETAIL);
 	strcpy(msg, "io_uring_cmd: ");
 
diff --git a/io_u.c b/io_u.c
index c49cd4df0237..b699169d79b5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -1956,7 +1956,8 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	log_err("fio: io_u error%s%s: %s: %s offset=%llu, buflen=%llu\n",
 		io_u->file ? " on file " : "",
 		io_u->file ? io_u->file->file_name : "",
-		strerror(io_u->error),
+		(io_u->flags & IO_U_F_DEVICE_ERROR) ?
+			"Device-specific error" : strerror(io_u->error),
 		io_ddir_name(io_u->ddir),
 		io_u->offset, io_u->xfer_buflen);
 
@@ -1965,8 +1966,10 @@ static void __io_u_log_error(struct thread_data *td, struct io_u *io_u)
 	if (td->io_ops->errdetails) {
 		char *err = td->io_ops->errdetails(td, io_u);
 
-		log_err("fio: %s\n", err);
-		free(err);
+		if (err) {
+			log_err("fio: %s\n", err);
+			free(err);
+		}
 	}
 
 	if (!td->error)
diff --git a/io_u.h b/io_u.h
index ab93d50f967e..20afad667ee1 100644
--- a/io_u.h
+++ b/io_u.h
@@ -22,6 +22,7 @@ enum {
 	IO_U_F_BARRIER		= 1 << 6,
 	IO_U_F_VER_LIST		= 1 << 7,
 	IO_U_F_PATTERN_DONE	= 1 << 8,
+	IO_U_F_DEVICE_ERROR	= 1 << 9,
 };
 
 /*
-- 
2.34.1

