Return-Path: <fio-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:59936 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1JOJoI (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 15 Oct 2011 05:44:08 -0400
Received: from merkaba.localnet (ppp-93-104-153-178.dynamic.mnet-online.de [93.104.153.178])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id F1EBFFB
	for <fio@vger.kernel.org>; Sat, 15 Oct 2011 11:44:05 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: engines like rdma engine that require additional dependencies
Date: Sat, 15 Oct 2011 11:44:05 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201110151144.06000.Martin@lichtvoll.de>
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi Jens!

I discussed with my package sponsor about whether to build rdma engine for 
fio 1.59 debian package or not. We decided to do it and see how it builds 
on all architectures.

But on installing fio now also two additional libs get installed and one of 
them creates a user named "rdma".

I wonder whether it would be feasible or good to have engines that require 
external dependencies as modules that could be packaged separately.

Might not matter much as long as its only the rdma engine tough.

What do you think?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
