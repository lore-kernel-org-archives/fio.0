Return-Path: <fio-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:39732 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932285AbdFLPtJ (ORCPT
        <rfc822;groupwise-fio@vger.kernel.org:0:0>);
        Mon, 12 Jun 2017 11:49:09 -0400
Date: Mon, 12 Jun 2017 17:48:53 +0200
From: Andreas Herrmann <aherrmann@suse.com>
Subject: [PATCH v2 0/2] stat: Modify info for bw and iops stats in
 normal/json output
Message-ID: <20170612154853.GH15590@suselix.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: fio@vger.kernel.org

From: Andreas Herrmann <aherrmann@suse.com>

Andreas Herrmann (2):
      stat: Provide iops statistics
      stat: Print number of samples in bw and iops statistics

 init.c   |  1 +
 server.c |  1 +
 stat.c   | 27 +++++++++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)
