Return-Path: <fio-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:23087 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936699AbZFPGAa (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 16 Jun 2009 02:00:30 -0400
Message-ID: <4A373307.4040009@oracle.com>
Date: Tue, 16 Jun 2009 11:22:07 +0530
From: Gurudas Pai <gurudas.pai@oracle.com>
MIME-Version: 1.0
Subject: Re: Periodic sync?
References: <f3177b9e0906151816q3eaeac73i79047866d4d487a2@mail.gmail.com>
In-Reply-To: <f3177b9e0906151816q3eaeac73i79047866d4d487a2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Chris Worley <worleys@gmail.com>
Cc: fio@vger.kernel.org

Hello Chris,

> Is there any way to tell fio to insert a periodically sync... not sync
> every I/O, but every N I/O's, or maybe on some period?

fsync=int       If writing to a file, issue a sync of the dirty data
                 for every number of blocks given. For example, if you give
                 32 as a parameter, fio will sync the file for every 32
                 writes issued. If fio is using non-buffered io, we may
                 not sync the file. The exception is the sg io engine, which
                 synchronizes the disk cache anyway.



This should help you.

Thanks,
-Guru
