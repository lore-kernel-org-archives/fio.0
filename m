Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:38335 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3G2Mde (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jul 2013 08:33:34 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so3899695wes.17
        for <fio@vger.kernel.org>; Mon, 29 Jul 2013 05:33:32 -0700 (PDT)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Mon, 29 Jul 2013 13:33:12 +0100
Message-ID: <CANUChTzkAwWuzpiN7hjiQQo_zNNdovEcZQgnTrM6V7M7ELD3eg@mail.gmail.com>
Subject: Does ioengine=sg support iodepth?
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

As per the subject, reading the How To seems to imply that on Linux
only the libaio engine supports the use of queue depth (iodepth), but
I thought SCSI Generic supports queue depths as well?

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
