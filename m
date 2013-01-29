Return-Path: <fio-owner@vger.kernel.org>
Received: from pbit-mailserver.permabit.com ([66.202.84.83]:38418 "EHLO
	pbit-mailserver.permabit.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086Ab3A2WJY (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 29 Jan 2013 17:09:24 -0500
From: Ken Raeburn <raeburn@permabit.com>
Subject: Re: [PATCH] Fix crash with absurdly but not impossibly deeply nested device stacks.
References: <6eham0rdc3.fsf@just-testing.permabit.com>
	<6ea9rsrc7u.fsf@just-testing.permabit.com>
	<20130129091712.GD30188@kernel.dk>
	<6e622fr967.fsf@just-testing.permabit.com>
	<20130129211501.GK8800@kernel.dk>
Date: Tue, 29 Jan 2013 17:09:22 -0500
In-Reply-To: <20130129211501.GK8800@kernel.dk> (Jens Axboe's message of "Tue,
	29 Jan 2013 22:15:01 +0100")
Message-ID: <6e1ud3r699.fsf@just-testing.permabit.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org


Sure, I'll work up some patches for the [v]snprintf calls and the
missing smalloc failure check...

Ken
