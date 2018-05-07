Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35667 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752726AbeEGUp7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 7 May 2018 16:45:59 -0400
Received: by mail-qk0-f173.google.com with SMTP id g4so5285206qki.2
        for <fio@vger.kernel.org>; Mon, 07 May 2018 13:45:59 -0700 (PDT)
MIME-Version: 1.0
From: abhishek koundal <akoundal@gmail.com>
Date: Mon, 7 May 2018 13:45:17 -0700
Message-ID: <CAKwzdDpOCbRCUHoH=XPQXVNApqgYRiRigfCnzfvW76y6QY_AkA@mail.gmail.com>
Subject: fio parameter query
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

All,
I was looking if there is any value in adding a parameter to flow
which does this scenario:
1) runtime=10s
2) logs all data 0-10s
3) calculated/reported values:  QoS/IOPS from e.g. 3s-10s. (i.e. only
use 7s worth of data as first 3 second doesn't need to be in
calculations).

-- 
Life is too short for silly things so invest your time in some
productive outputs!!
