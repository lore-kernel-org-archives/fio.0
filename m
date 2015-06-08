Return-Path: <fio-owner@vger.kernel.org>
Received: from cas081-co-2.exch081.serverdata.net ([199.193.204.183]:23064
	"EHLO out.west.exch081.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751075AbbFHT27 convert rfc822-to-8bit
	(ORCPT <rfc822;fio@vger.kernel.org>); Mon, 8 Jun 2015 15:28:59 -0400
From: Carl Zwanzig <cpz@intermodaldata.com>
Subject: RE: what is the difference? start 2 fio instances and setting
 numjobs=2 ..
Date: Mon, 8 Jun 2015 19:20:54 +0000
Message-ID: <53e703ba9b2c415a999c4860b61e75b7@mbx081-w4-co-1.exch081.serverpod.net>
References: <loom.20150608T164659-812@post.gmane.org>
In-Reply-To: <loom.20150608T164659-812@post.gmane.org>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: QB <viali.lee.mail@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>

> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of QB
> Sent: Monday, June 08, 2015 7:49 AM
> To: fio@vger.kernel.org

> Hi, just a stupid question..
> what is the difference with the following 2 options:
> 1. starting 2 FIO instances with the same parameter settings
> 2. starting 1 FIO instances with numjobs=2..

At the basic level, fio's control process spawns a separate data mover process for each job, so with numjobs=2 you have 1 control proc and two data procs v. 2 control and 2 data when invoked separately.

z!

