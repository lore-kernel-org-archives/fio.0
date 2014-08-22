Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40120 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaHVBBh convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 21 Aug 2014 21:01:37 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so15471630pac.31
        for <fio@vger.kernel.org>; Thu, 21 Aug 2014 18:01:36 -0700 (PDT)
Received: from dyn-133.datrium.com ([66.201.50.146])
        by mx.google.com with ESMTPSA id s16sm18265463pdj.21.2014.08.21.18.01.36
        for <fio@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 21 Aug 2014 18:01:36 -0700 (PDT)
From: Surendar Chandra <surendar@datrium.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: buffer_pattern usage question
Message-Id: <3DB5F5EE-7D4F-487B-B757-BAD37D041DEB@datrium.com>
Date: Thu, 21 Aug 2014 18:01:36 -0700
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Could you please help me with this setup

   filename=fio-data
   size=4k
   rw=write
   buffer_pattern="HELLO" 

The output still continues to be pseudo random. I even tried buffer_pattern=0xDEADBEEF and other params. 

Thanks much for your help