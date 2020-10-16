CFMEncrypt.cpp
Rick Osborne <rick@rixsoft.com>
http://www.rixsoft.com/ColdFusion/CFX/CFMEncrypt/
2000-05-28

This is all based on the original source by Matt Chapman
<matthewc@cse.unsw.edu.au>

Purpose:
  Encrypts and decrypts CFML templates.  Encryption, like CFCRYPT.EXE,
  produces executable CFML templates.  Decryption performs just like
  the CFDECRYPT utility by Matt Chapman.  You now have both sets of
  functionality in a CFX tag.  Go to town.

Reference:
  http://packetstorm.securify.com/9907-exploits/cfdecrypt.txt
  http://shroom.dv8.org/bmp/crypt.cgi
  http://www.rewted.org/exploits/sorted-by-date/07-1999/cfdecrypt.c

Decryption Procedure:
  1. Get the header size from the top of the file (it is in plaintext).
     For version 1 encryption, the custom header is included in this
     number, but version 2 encrypts the header with the sourcecode and has
     some extra junk for the next 16 bytes.  (Don't know what this is yet.)
  2. Setup your DES.
  3. Decrypt the ciphertext in 8-byte chunks.
     a. If you are using version 2 system, look for the first 0x1a to signal
     the end of the custom header
  4. The remaining bytes in the file are just XORed with their position
     past the header.  (Hint: Don't store your passwords in the last 7
     bytes! ;)

Encryption Procedure:
  1. Write the header, including the size and the custom header.
  2. Setup your DES.
  3. Encrypt the plaintext in 8-byte chunks.
  4. The remaining bytes in the file are just XORed with their position
     past the header.

Usage:

  Parameters:
    MODE="ENCRYPT|DECRYPT" (required)
    INFILE="(filename)" (not required if you have INPUT instead)
    INPUT="(text)" (not required if you have INFILE instead)
    OUTFILE="(filename)" (not required if you have OUTPUT instead)
    OUTPUT="(text)" (not required if you have OUTFILE instead)
    HEADER="(text)" (custom header text for ENCRYPT -- not required)
    ERROR="(varname)" (not required -- defaults to CFMEncrypt.Error)

  Example:
    <!--- Add Yahoo/Geocities-style footers --->
    <CFX_CFMENCRYPT MODE="DECRYPT" INFILE="source.cfm" OUTPUT="Source" ERROR="ThisError">
    <CFIF ThisError IS NOT "">
      <CFABORT SHOWERROR="Could not decrypt! #ThisError#">
    </CFIF>
    <CFSET Custom=Source & Chr(13) & Chr(10) & "<P>Thank's for using Rick's server!</P>">
    <CFX_CFMENCRYPT MODE="ENCRYPT" INPUT="#Custom#" OUTFILE="source.cfm" HEADER="Hosted by Rick">

Notes:
  - Anything coming out of an ENCRYPT operation, or into a DECRYPT
    operation, is binary data.  I suggest you don't try to manipulate
    this in variables.  That's what files are for.
  - Note: This version only does version 1 format files.  Until I figure
    out what the extra 16 bytes in the new version are, I don't want to
    mess with version 2.  Besides, it works.

Creative uses:
  - Become a CF service host that uses only the ADK.  Provide web-based file
    upload that automagically encrypts templates as they are uploaded.
    Save yourself lots of money by not having to buy the full version.
  - "Safety scan" templates that you don't have control over.  (Find
    people trying to use the hidden admin functions when they shouldn't be.)
  - Write some CF scripts to run nightly:
    1. Check out the stable source tree from your version control software.
    2. Encrypt the source.
    3. Upload the encrypted source to your clients.
  - Write a "Windows Update"/"LiveUpdate" kind of on-demand updating for your
    production code:
    1. Code on client end checks in nightly for revisions.
    2. When new things are found, encrypt them and send them.

Why use this and not CFCRYPT.EXE?
  No major reasons.  Maybe you don't want to use CFEXECUTE.  Maybe this is
  actually faster than shelling out every time you want to encrypt a
  template.

Installation:
  Install this just as you would any other CFX tag.  Note that the ZIP file
  should come with two versions: Debug and Release.  You only need to install
  one of them.

