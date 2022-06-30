if (document.URL.match("mymenus/new") || document.URL.match(/edit/)) {
  document.addEventListener('DOMContentLoaded', () => {

    const createImageHTML = (blob) => {
      const imageElement = document.getElementById('new-image');
      const blobImage = document.createElement('img');
      blobImage.setAttribute('id', 'new-img')
      blobImage.setAttribute('src', blob);
      imageElement.appendChild(blobImage);
      document.getElementById('no-image').style.width = "0px";
      document.getElementById('no-image').style.visibility = "hidden";
      if (document.getElementById("mymenu_remove_image")) {
        document.getElementById("mymenu_remove_image").value = "0";
      }
    };

    document.getElementById('fileCheck').addEventListener('change', (e) => {
      const imageContent = document.getElementById('new-img');
      if (imageContent) {
        imageContent.remove();
      }
      const file = e.target.files[0];
      const blob = window.URL.createObjectURL(file);
      createImageHTML(blob);
    });

    function inputCheck() {
      let fileCheck = document.getElementById("fileCheck");
      let fileCheckBtn = document.getElementById("fileCheckBtn");
      let image_cache = document.getElementById("mymenu_image_cache");
      // 削除ボタンの表示・非表示処理
      // if (fileCheck.files.length === 0 && image_cache.value.length === 0) {
      //   fileCheckBtn.hidden = true;
      // } else {
      //   fileCheckBtn.hidden = false;
      // }
    }

    inputCheck();

    document.getElementById("fileCheck").addEventListener('change', function(e) {
      inputCheck();
    });

    // 画像が入っている場合削除ボタンを出現させる
    // document.getElementById("fileCheckBtn").addEventListener('click', function(e) {
    //   document.getElementById('new-img').remove();
    //   document.getElementById('no-image').style.width = "120px";;
    //   document.getElementById('no-image').style.visibility = "visible";
    //   document.getElementById("fileCheck").value = "";
    //   document.getElementById("mymenu_image_cache").value = "";
    //   console.log(document.getElementById("mymenu_remove_image").length)
    //   if (document.getElementById("mymenu_remove_image")) {
    //     document.getElementById("mymenu_remove_image").value = "1";
    //   }
    //   inputCheck();
    // });
  });
}
