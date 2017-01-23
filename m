Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35182 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750723AbdAWNNu (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 Jan 2017 08:13:50 -0500
Received: by mail-wm0-f54.google.com with SMTP id r126so132248125wmr.0
        for <fio@vger.kernel.org>; Mon, 23 Jan 2017 05:13:50 -0800 (PST)
Subject: Re: Removing *.py ending from python script filenames
References: <2172844.j6hkAc7SIx@merkaba>
From: Tobias Oberstein <tobias.oberstein@gmail.com>
Message-ID: <9434c258-a14b-aba7-4093-71cf560f00a3@gmail.com>
Date: Mon, 23 Jan 2017 14:13:47 +0100
MIME-Version: 1.0
In-Reply-To: <2172844.j6hkAc7SIx@merkaba>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Martin Steigerwald <martin.steigerwald@teamix.de>, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@sandisk.com>, Mark Nelson <mnelson@redhat.com>, Ben England <bengland@redhat.com>, Karl Cronburg <karl.cronburg@gmail.com>, Jens Axboe <axboe@kernel.dk>, Sven Hoexter <hoexter@debian.org>

Hi,

just subscribed here for other reasons and stumbled across this, but 
since I know about Python packaging:

The "right way" (in as, understood and common to the Python community) 
to distribute Python scripts that are supposed to be installed and run 
from command line is to first package up the Python stuff as a proper 
Python package and then follow

http://python-packaging.readthedocs.io/en/latest/command-line-scripts.html#the-console-scripts-entry-point

For example

https://github.com/crossbario/crossbar/blob/master/setup.py#L98

This will install a proper wrapper with no extension. It will also allow 
to use the Python stuff from Python by mere importing the wrapped function.

(cpy3_1) oberstet@thinkpad-t430s:~/scm/crossbario/crossbario-organize$ 
which crossbar
/home/oberstet/python/cpy3_1/bin/crossbar

(cpy3_1) oberstet@thinkpad-t430s:~/scm/crossbario/crossbario-organize$ 
cat `which crossbar`
#!/home/oberstet/python/cpy3_1/bin/python3
# EASY-INSTALL-ENTRY-SCRIPT: 'crossbar','console_scripts','crossbar'
__requires__ = 'crossbar'
import re
import sys
from pkg_resources import load_entry_point

if __name__ == '__main__':
     sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
     sys.exit(
         load_entry_point('crossbar', 'console_scripts', 'crossbar')()
     )
(cpy3_1) oberstet@thinkpad-t430s:~/scm/crossbario/crossbario-organize$

Cheers,
/Tobias

PS: Also, please consider publishing the Python package to PyPI too (eg 
for people that find distro packages annoying, eg because they use 
virtualenv or what)
