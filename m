Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:50312 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZIDSrb (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 4 Sep 2009 14:47:31 -0400
Received: by pzk16 with SMTP id 16so1025757pzk.18
        for <fio@vger.kernel.org>; Fri, 04 Sep 2009 11:47:33 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Sep 2009 12:40:17 -0600
Message-ID: <f3177b9e0909041140nb792fdav610cec98f69c2836@mail.gmail.com>
Subject: Proper use of "--verify" switch
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Are there example uses, specifically for mixed read/write cases?

I've found I can do sequential writes followed by sequential reads w/o
issue, but have errors in other cases.

Just some usage hints would be nice.

Thanks,

Chris
