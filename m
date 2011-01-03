Return-Path: <fio-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([64.244.102.30]:44120 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914Ab1ACLDL (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 3 Jan 2011 06:03:11 -0500
Message-ID: <4D21AD43.3090200@fusionio.com>
Date: Mon, 3 Jan 2011 12:04:35 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
Subject: Re: Suggestion on size= and test length
References: <4D1FFB19.7020202@shiftmail.org>
In-Reply-To: <4D1FFB19.7020202@shiftmail.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Cc: fio@vger.kernel.org

On 2011-01-02 05:12, Spelic wrote:
> Dear fio developers,
> 
> Thanks for the very good application, but may I suggest that the size=
> option controls only the size of the files used for the test (in
> particular random r/w tests), while there should be another option
> totaltransfer= which controls how long is the test? And/or a walltime=
> option to make the test length time based... even better!
> 
> Currently we either are hit by short seeks (size= small) or have to
> wait for impossibly long tests uselessly (size= large).

What about just adding a runtime= setting to shorten the run? Use the
full size, but put a cap on runtime.

-- 
Jens Axboe

