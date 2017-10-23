Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:56735 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdJWF7G (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Oct 2017 01:59:06 -0400
Received: by mail-io0-f182.google.com with SMTP id m81so18887758ioi.13
        for <fio@vger.kernel.org>; Sun, 22 Oct 2017 22:59:06 -0700 (PDT)
MIME-Version: 1.0
From: qingwei wei <tchengwee@gmail.com>
Date: Mon, 23 Oct 2017 13:59:05 +0800
Message-ID: <CAGjEAhugzO6y4K2426xcnyFmOvTLH+mw5BU3ofA6DNiw1Rjn2w@mail.gmail.com>
Subject: FIO workload profile for VMS Server
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am currently looking at simulating IO workload for VMS server. I
read that usually VMS has recording server and each recording server
can support up to a number of IP camera. For example, if recording
server can support up to 150 IP cameras, does it means i will need to
configure 150 jobs in FIO to simulate that? And what is the typical
file size for the recorded video stream? Thanks.

Regards,

Cw
