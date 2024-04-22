Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A5154C12
	for <fio@vger.kernel.org>; Mon, 22 Apr 2024 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713808555; cv=none; b=VEt/aujvk0QcS1x7jrb2PyMzBgmwvSrGjyU0GCC4nwuqZTV4jZHSFxs5DqEtwuiJyLdHq2f7yWNkVvBTw2C9q8tYGIRIlH3nsN6cXxJWLCQj+n59Edw0+BW21O5qwqni03VSG8we/Rb+oeJtgFpysem6r77lFacbQ+rt7rjOK9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713808555; c=relaxed/simple;
	bh=xhsegur+g64XnKSBZCPuOpTDV35Uq8J2fLF8awMc3Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LypPd0qXhZsp8jZnDtjWi0Z9RB4t0U6o6HeppPFJgwV1glJH2pBys5ZQ8tdPMuaZYTvWmi4I4ktKrC12IBsj82NkUGB0JL58WtRQ3BEYwvmmAOguQzgB4z2HnDs1biySm1le0mHdKxo5CfAZLzKmFNWWxJSMUPTEHIYVR3M+/Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UCDn/3U3; arc=none smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UCDn/3U3"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3c75139645aso1471126b6e.1
        for <fio@vger.kernel.org>; Mon, 22 Apr 2024 10:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713808553; x=1714413353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wx7OMeo3plpX4xQSD8cvtuF0mfVO+MGquGe+yDL+KQc=;
        b=UCDn/3U381pemlWg6fHg+kqLkNfwc37SRICSlMyohzzY0YTuS16bLmQzfrYB832oqh
         mSofTKdg6OdKOC/yqKonB/5HUOcZUTcfiDL37+ekflKRWjdXayn1M/B5mbAi25eYQumR
         Fl+3WwCUtUJ0fpgvmbApKEFnwvAmMQdOV/BHf/lQ3zekjcOhOMMGjmh+o2Qn7F30brSX
         /hWjg60E79mBFXjb+1K/qZHHjcnPxmwQYvmHvy62k713YFDq1B+NjAL2/23ViEO9JphI
         fB/6Sap99oBjkDOFDDpvqnHtS46Q7WdwbvOt3dzqA0XZIKxSxcW/uU+Ske0EWwIc3CQK
         e/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713808553; x=1714413353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wx7OMeo3plpX4xQSD8cvtuF0mfVO+MGquGe+yDL+KQc=;
        b=MGYyfYJm4zPEbZktF2Ut8iD5r7JgOpXBpLXSAe7UHbcxTg0smovHQsAezzqdHze2K0
         hxBcoRmxHLPFXoNtod3mRHCXEF7g8DOPQNanTivlNU7qSFHMaUPFW21LZRhbeKWMaFdA
         OIdSQcLps+gXvp+Irky+eYuVhP3pAKSxrcXOhmfp3Kdgs1VoiAlxjss9gwZz8fqntH8/
         juUr4fsaxc4ZLO0mFXMSxiG0EDeDUJDPW/Hml3pIyvAJeZ+i2dyXPd6sjyLYquoYvst7
         qO8WZOf5wvipNOfbQz4qgWK+BkY1iPEI4kHvJfm48ijLb1VumubuubBfGdQ6JndnIifk
         1BAA==
X-Forwarded-Encrypted: i=1; AJvYcCXzVjVgK8dPitPQp9cMZtC42K5o0RNOm3Ue8+d0YwAg1iuf5lnrBeUknmWo4VmacHRSZjk0k6BBdCTZ1hEA2E3DZqcX
X-Gm-Message-State: AOJu0Yw54DOBBsnJ8QGB57q82Hmje/rEd2vTJ32m5gbNLVI1lc8T0Gyn
	SiSnupYEQlPNd1qeUy6T1ow/EQn/k3M/xrHstKi+5kNoW1A3NavwDPA/Iw==
X-Google-Smtp-Source: AGHT+IFMOuuiCZQjiCcgQSFt48s13h2Uu6poB2reDsUliq03Qifpa9DYXY3QHgUQCs/PfOuLpEH4TQ==
X-Received: by 2002:a54:4584:0:b0:3c8:2fc5:c816 with SMTP id z4-20020a544584000000b003c82fc5c816mr2951703oib.11.1713808552575;
        Mon, 22 Apr 2024 10:55:52 -0700 (PDT)
Received: from fio-dev.vincentfu.org. (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.googlemail.com with ESMTPSA id a7-20020a0cca87000000b0069b82585f7bsm4392727qvk.21.2024.04.22.10.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Apr 2024 10:55:51 -0700 (PDT)
From: Vincent Fu <vincentfu@gmail.com>
X-Google-Original-From: Vincent Fu <vincent.fu@samsung.com>
To: axboe@kernel.dk,
	ankit.kumar@samsung.com,
	kbusch@kernel.org,
	fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 9/9] docs: update for new data placement options
Date: Mon, 22 Apr 2024 13:49:55 -0400
Message-ID: <20240422175522.4614-10-vincent.fu@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240422175522.4614-1-vincent.fu@samsung.com>
References: <20240422175522.4614-1-vincent.fu@samsung.com>
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update the HOWTO and man page for the unified data placement options
that cover both FDP and Streams.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO.rst | 36 +++++++++++++++++++++++++++---------
 fio.1     | 35 ++++++++++++++++++++++++++++-------
 2 files changed, 55 insertions(+), 16 deletions(-)

diff --git a/HOWTO.rst b/HOWTO.rst
index 2f108e36..2f8ef6d4 100644
--- a/HOWTO.rst
+++ b/HOWTO.rst
@@ -2500,7 +2500,24 @@ with the caveat that when used on the command line, they must come after the
 
 	Enable Flexible Data Placement mode for write commands.
 
-.. option:: fdp_pli_select=str : [io_uring_cmd] [xnvme]
+.. option:: dataplacement=str : [io_uring_cmd] [xnvme]
+
+        Specifies the data placement directive type to use for write commands.
+        The following types are supported:
+
+                **none**
+                        Do not use a data placement directive. This is the
+                        default.
+
+                **fdp**
+                        Use Flexible Data Placement directives for write
+                        commands. This is equivalent to specifying
+                        :option:`fdp` =1.
+
+               **streams**
+                        Use Streams directives for write commands.
+
+.. option:: plid_select=str, fdp_pli_select=str : [io_uring_cmd] [xnvme]
 
 	Defines how fio decides which placement ID to use next. The following
 	types are defined:
@@ -2512,16 +2529,17 @@ with the caveat that when used on the command line, they must come after the
 			Round robin over available placement IDs. This is the
 			default.
 
-	The available placement ID index/indices is defined by the option
-	:option:`fdp_pli`.
+	The available placement ID (indices) are defined by the option
+	:option:`plids`.
 
-.. option:: fdp_pli=str : [io_uring_cmd] [xnvme]
+.. option:: plids=str, fdp_pli=str : [io_uring_cmd] [xnvme]
 
-	Select which Placement ID Index/Indicies this job is allowed to use for
-	writes. By default, the job will cycle through all available Placement
-        IDs, so use this to isolate these identifiers to specific jobs. If you
-        want fio to use placement identifier only at indices 0, 2 and 5 specify
-        ``fdp_pli=0,2,5``.
+        Select which Placement IDs (streams) or Placement ID Indices (FDP) this
+        job is allowed to use for writes. For FDP by default, the job will
+        cycle through all available Placement IDs, so use this to isolate these
+        identifiers to specific jobs. If you want fio to use FDP placement
+        identifiers only at indices 0, 2 and 5 specify ``plids=0,2,5``. For
+        streams this should be a comma-separated list of Stream IDs.
 
 .. option:: md_per_io_size=int : [io_uring_cmd] [xnvme]
 
diff --git a/fio.1 b/fio.1
index 5fd3603d..ee812494 100644
--- a/fio.1
+++ b/fio.1
@@ -2264,7 +2264,26 @@ file blocks are fully allocated and the disk request could be issued immediately
 .BI (io_uring_cmd,xnvme)fdp \fR=\fPbool
 Enable Flexible Data Placement mode for write commands.
 .TP
-.BI (io_uring_cmd,xnvme)fdp_pli_select \fR=\fPstr
+.BI (io_uring_cmd,xnvme)dataplacement \fR=\fPstr
+Specifies the data placement directive type to use for write commands. The
+following types are supported:
+.RS
+.RS
+.TP
+.B none
+Do not use a data placement directive. This is the default.
+.TP
+.B fdp
+Use Flexible Data placement directives for write commands. This is equivalent
+to specifying \fBfdp\fR=1.
+.TP
+.B streams
+Use Streams directives for write commands.
+.TP
+.RE
+.RE
+.TP
+.BI (io_uring_cmd,xnvme)plid_select=str, fdp_pli_select \fR=\fPstr
 Defines how fio decides which placement ID to use next. The following types
 are defined:
 .RS
@@ -2277,14 +2296,16 @@ Choose a placement ID at random (uniform).
 Round robin over available placement IDs. This is the default.
 .RE
 .P
-The available placement ID index/indices is defined by \fBfdp_pli\fR option.
+The available placement ID (indices) are defined by the \fBplids\fR option.
 .RE
 .TP
-.BI (io_uring_cmd,xnvme)fdp_pli \fR=\fPstr
-Select which Placement ID Index/Indicies this job is allowed to use for writes.
-By default, the job will cycle through all available Placement IDs, so use this
-to isolate these identifiers to specific jobs. If you want fio to use placement
-identifier only at indices 0, 2 and 5 specify, you would set `fdp_pli=0,2,5`.
+.BI (io_uring_cmd,xnvme)plids=str, fdp_pli \fR=\fPstr
+Select which Placement IDs (streams) or Placement ID Indicies (FDP) this job is
+allowed to use for writes.  For FDP by default, the job will cycle through all
+available Placement IDs, so use this to isolate these identifiers to specific
+jobs. If you want fio to use placement identifier only at indices 0, 2 and 5
+specify, you would set `plids=0,2,5`. For streams this should be a
+comma-separated list of Stream IDs.
 .TP
 .BI (io_uring_cmd,xnvme)md_per_io_size \fR=\fPint
 Size in bytes for separate metadata buffer per IO. Default: 0.
-- 
2.43.0

