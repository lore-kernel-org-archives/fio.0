Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B66FCC433F5
	for <fio@archiver.kernel.org>; Thu,  7 Apr 2022 14:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiDGOwj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 7 Apr 2022 10:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344291AbiDGOw0 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 7 Apr 2022 10:52:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF031C9B6A
        for <fio@vger.kernel.org>; Thu,  7 Apr 2022 07:50:13 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2370fhw6004358
        for <fio@vger.kernel.org>; Thu, 7 Apr 2022 07:50:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=WjBEXpHgHI1p+BV76H1VYKYFFnzh9tYlVEW+hTbqTFk=;
 b=MtPNZh2Pz+4Nw0GgM+dIqsNXpDAd7+Hem1/ACC4+p48tzCa7ItZAWCpfd+kZ0JQcFjPZ
 6v8GDyczpdH6RNolfV8AHK5AC1sZxLIpxgfmDrJd4E7z5lbP0uGJuD89s8UO2xIqu5tJ
 MHPEzAanm6aO2/0kkf3QBP2INhtl9NZ8abw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3f9chk0yde-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <fio@vger.kernel.org>; Thu, 07 Apr 2022 07:50:05 -0700
Received: from twshared8508.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 7 Apr 2022 07:50:03 -0700
Received: by devvm4279.ftw0.facebook.com (Postfix, from userid 199637)
        id A155520E9FF72; Thu,  7 Apr 2022 07:49:59 -0700 (PDT)
From:   Mohamad Gebai <mogeb@fb.com>
To:     <fio@vger.kernel.org>
CC:     Mohamad Gebai <mogeb@fb.com>
Subject: [PATCH v2 0/3] iolog: add version 3 with timestamp support
Date:   Thu, 7 Apr 2022 07:49:55 -0700
Message-ID: <20220407144958.3975622-1-mogeb@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Gxz_PrWIHg0ltJfJlrDJ70mYSUTnoxT4
X-Proofpoint-ORIG-GUID: Gxz_PrWIHg0ltJfJlrDJ70mYSUTnoxT4
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

Changes from v1:
* Add commit messages to #2 and #3, and fix the format of #1.
* Store fio_gettime() in td->last_issue directly rather than memcpying
to it in commit #1.

Mohamad Gebai (3):
  iolog: add version 3 to support timestamp-based replay
  iolog: add iolog_write for version 3
  iolog: update man page for version 3

 HOWTO.rst  |  29 ++++++++++++++-
 blktrace.c |  17 ++-------
 fio.h      |   4 ++-
 iolog.c    | 104 ++++++++++++++++++++++++++++++++++++++++++-----------
 iolog.h    |   8 ++---
 5 files changed, 121 insertions(+), 41 deletions(-)

--=20
2.30.2

