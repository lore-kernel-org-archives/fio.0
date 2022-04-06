Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D046DC433F5
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 18:13:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240374AbiDFSPx (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 6 Apr 2022 14:15:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240393AbiDFSPi (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 6 Apr 2022 14:15:38 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E92BBCAB
        for <fio@vger.kernel.org>; Wed,  6 Apr 2022 10:05:41 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2366TXgx022650
        for <fio@vger.kernel.org>; Wed, 6 Apr 2022 10:05:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=207784ukwa1Clxrsw50kRd/0wh1FUBHoUkO7l8Nf0dA=;
 b=I1y2b5VU5t2M/bIqvNtRLz6Utcx/0QjCC1VQs6SQcxyKLxLx4HchPCYWGLczW+17O3n0
 DLOaOSmwC+lZDF6AQD0tdmND3I+nai/4u/pzTlFmfloVwhbFCS5e+g+PrgAPWRavvUQg
 Y7gzJRyo0TCHB6sATe3hnv67FUIMx0LSVq0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f8k313836-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Wed, 06 Apr 2022 10:05:40 -0700
Received: from twshared16483.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 6 Apr 2022 10:05:39 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id 1C51620D98DAB; Wed,  6 Apr 2022 10:05:32 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH 0/3] iolog: add version 3 with timestamp support
Date:   Wed, 6 Apr 2022 10:05:27 -0700
Message-ID: <20220406170530.2198263-1-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 6jGRP91MR4qQ_0k6-YP-uQPJLPeMUnrn
X-Proofpoint-GUID: 6jGRP91MR4qQ_0k6-YP-uQPJLPeMUnrn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_09,2022-04-06_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This set of patches introduces version 3 of the iolog replay. This
version adds support for timestamps on both iolog_read and iolog_write.
The 'wait' action is no longer supported with version 3, as the same
behavior can be achieved with timestamps, and it keeps the iolog file
easier to follow. This could also allow to potentially deprecate the
'wait' action eventially.

Mohamad Gebai (3):
  iolog: add version 3 to support timestamp-based replay
  iolog: add iolog_write for version 3
  iolog: update man page

 HOWTO.rst  |  29 +++++++++++++-
 blktrace.c |  17 ++------
 fio.h      |   4 +-
 iolog.c    | 114 +++++++++++++++++++++++++++++++++++++++++------------
 iolog.h    |   8 ++--
 5 files changed, 127 insertions(+), 45 deletions(-)

--=20
2.30.2

