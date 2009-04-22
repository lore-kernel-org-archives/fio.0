Return-Path: <fio-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:20096 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZDVF6u (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 22 Apr 2009 01:58:50 -0400
Message-ID: <49EEB0D2.5030200@oracle.com>
Date: Wed, 22 Apr 2009 11:23:22 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
MIME-Version: 1.0
Subject: Re: Recent changes
References: <20090421191545.GO4593@kernel.dk> <669351.35730.qm@web63805.mail.re1.yahoo.com> <20090422054614.GT4593@kernel.dk>
In-Reply-To: <20090422054614.GT4593@kernel.dk>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Girish Satihal <girish.satihal@yahoo.com>
Cc: fio@vger.kernel.org

Girish,

> The reason for saying ext3, is I run fdisk on /dev/cciss/c1d0 and created a primary partition.
> Then I created a ext3 filesystem on this partition by running mkefs and mounted this partition 
 > on /mnt folder. Then I run fio on this partition.
you run it on disk directly(/dev/cciss/c1d0) without mounting it on /mnt.


Thanks,
-Guru
