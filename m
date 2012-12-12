Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44501 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753723Ab2LLBXJ (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 11 Dec 2012 20:23:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so78535pbc.19
        for <fio@vger.kernel.org>; Tue, 11 Dec 2012 17:23:08 -0800 (PST)
Message-ID: <50C7DC7A.5000806@aeoncomputing.com>
Date: Tue, 11 Dec 2012 17:23:06 -0800
From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
MIME-Version: 1.0
Subject: Can fio be compiled as a static binary?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Greetings,

Is there a way to compile fio as a static binary? I have to use it on 
different Linux machines from time to time and I'd like to not alter the 
OS image by installing libaio-devel, etc. In some cases I am not able to 
make any changes to the installed OS image.

I performed a git checkout of fio and I wanted to ask if there was an 
existing/known method to derive a static fio binary from the existing 
source tree before I make any modifications or attempts on my own.

Thanks!
