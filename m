Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.valinux.co.jp ([210.128.90.3]:42298 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0FWEk1 (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 23 Jun 2010 00:40:27 -0400
Subject: --latency-log
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20100623044026.DB65571923@kuma.localdomain>
Date: Wed, 23 Jun 2010 13:40:26 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

hi,

the --latency-log option merely sets the write_lat_log global variable,
which doesn't seem to be used at all.

YAMAMOTO Takashi
