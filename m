Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66443C433FE
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 17:40:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiDGRmo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 13:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237007AbiDGRmn (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 13:42:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9871F124A
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 10:40:43 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 237FgZqS030525
        for <fio@vger.kernel.org>; Thu, 7 Apr 2022 10:40:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=IDhhpzcVF8b6dxLfFn853qsMixslx/4lx1hA7I1oBTs=;
 b=aM0qwVWpOCwpkOHKH6utsK7QXpirG3ur/FvUWZUOIDnEcFhrQRvnybgVwes6YRo0p0iU
 VJTU0Ts67mpHpGckFMnekCwhEpU+b4Dk8Gk5hy7PfIcpFEz+rgq/VKTm4WnH3NCbhlNx
 EGQgRJ8Qc6p6FzcvH2fWMVp2pBpwXWhQWQM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f9gmr0713-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 07 Apr 2022 10:40:43 -0700
Received: from twshared13345.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 10:40:41 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id 944FD20EC407E; Thu,  7 Apr 2022 10:40:32 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH v3 0/3] iolog: add version 3 with timestamp support
Date:   Thu, 7 Apr 2022 10:40:28 -0700
Message-ID: <20220407174031.599117-1-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 2SgDTa5Odu0LDk5MDbXdqdBG5tcXjPQ9
X-Proofpoint-GUID: 2SgDTa5Odu0LDk5MDbXdqdBG5tcXjPQ9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_03,2022-04-07_01,2022-02-23_01
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This set of patches introduces version 3 of the iolog replay. This
version adds support for timestamps on both iolog_read and iolog_write.
The 'wait' action is no longer supported with version 3, as the same
behavior can be achieved with timestamps, and it keeps the iolog file
easier to follow. This could also allow to potentially deprecate the
'wait' action eventually.

Changes from v2:
* Update documentation in fio.1.

Mohamad Gebai (3):
  iolog: add version 3 to support timestamp-based replay
  iolog: add iolog_write for version 3
  iolog: update man page for version 3

 HOWTO.rst  |  29 ++++++++++++++-
 blktrace.c |  17 ++-------
 fio.1      |  35 +++++++++++++++++-
 fio.h      |   4 ++-
 iolog.c    | 104 ++++++++++++++++++++++++++++++++++++++++++-----------
 iolog.h    |   8 ++---
 6 files changed, 155 insertions(+), 42 deletions(-)

--=20
2.30.2

