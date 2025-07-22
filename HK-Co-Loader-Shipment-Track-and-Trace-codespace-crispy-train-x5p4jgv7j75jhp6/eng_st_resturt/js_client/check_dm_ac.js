function strip( instring )
{
  var outstring="";
  var bit="";
  var founddigit=false;

  for( j=0;j<instring.length;j++ ) {
    c=instring.charAt(j);
    if( c != " " && c !="\t" && c !="\n"  && c !="\r" ) {
      if( founddigit == true )
        outstring+=bit;
      bit="";
      outstring+=c;
      founddigit=true;
    }
    else if( founddigit == true )
      bit+=c;
  }
  return outstring;
}

function checkAC(accountList,noCol,noRow)
{
  var errors="";	
  var accounts=new Array;
  var tmp="";
  var curr=0;
  account=strip(accountList);
  for(i=0;i<account.length;i++) {
   
    c=account.charAt( i );
    d=parseInt( c );
    if( ( msie3==true && !( d==0 && c != "0" ) ) || ( msie3==false && !isNaN( d ) ) ) {
      tmp+=c;
    } else {
      if( tmp != "" ) {
        accounts[curr]=tmp;
        curr++;
        tmp="";
      }
    }
   }//for
  
  if( tmp != "" )
    accounts[curr]=tmp;

  num=accounts.length;
 	  
   
  if( num == 0 )
  {
     errors="-1"
     return errors;
  }


  if( num > noRow  ) {
     errors="-2"
     return errors;
  }
  row=0;
  for( i=0 ; i< num ; i++ ) {
    accounts[i]=strip( accounts[i] );
    if( accounts[i].length != noCol && !isNaN( accounts[i] ) ) {
     row=i+1;
     errors+=" "+row;
    }
  }
  if (row !=0 ) {
   return errors;
  }
  return "0";
}

