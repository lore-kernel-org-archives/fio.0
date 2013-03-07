Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43746 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3CGN71 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 7 Mar 2013 08:59:27 -0500
Received: by mail-wg0-f48.google.com with SMTP id 16so863288wgi.3
        for <fio@vger.kernel.org>; Thu, 07 Mar 2013 05:59:26 -0800 (PST)
MIME-Version: 1.0
From: Gavin Martin <gavin_martin@xyratex.com>
Date: Thu, 7 Mar 2013 13:59:02 +0000
Message-ID: <CANUChTzsrxWbxWUS_wQ4eWJ_jVktL=DXvzGqn0U4aCukKWMmew@mail.gmail.com>
Subject: Reserved Keywords & Offset Percentage
Content-Type: text/plain; charset=US-ASCII
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Does Fio know the MaxLBA for devices it runs to?  If the size variable
has a percentage value, for example 50%, then it must have to read the
MaxLBA to know that on a 4TB drive the size of file we want is 2TB?
Is this correct or does it use another method?

If so would it be possible to have a reserved keyword for the MaxLBA,
much as you do currently for pagesize, memory & cpu's so that the size
& offset variable could make use of it, with the simple math
supported?

Not being a programmer and having very limited knowledge when it comes
to reading code, I have no idea if this is even possible within Fio?

If the above is not suitable, would it be possible for the offset
variable to accept percentages much like the size variable?

This comes from wanting to run Fio from dual hosts, I need to be able
to control which parts of the disk each host can access, so that they
do not interfere, on drives & ssds of many different sizes.

Basic example:

[Host 1]
size=50%
offset=0

[Host 2]
size=50%
offset 50%

Thanks,
Gavin

-- 


------------------------------
For additional information including the registered office and the treatment of Xyratex confidential information please visit www.xyratex.com

------------------------------
