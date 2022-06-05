if (document.URL.match(/new/)) {
  document.addEventListener('DOMContentLoaded', () => {

    const createImageHTML = (blob) => {
      const imageElement = document.getElementById('new-image');
      const blobImage = document.createElement('img');
      blobImage.setAttribute('id', 'new-img')
      blobImage.setAttribute('src', blob);
      imageElement.appendChild(blobImage);
      document.getElementById('no-image').style.width = "0px";
      document.getElementById('no-image').style.visibility = "hidden";
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
      if (fileCheck.files.length == 0) {
        fileCheckBtn.hidden = true;
      } else {
        fileCheckBtn.hidden = false;
      }
    }

    inputCheck();

    document.getElementById("fileCheck").addEventListener('change', function(e) {
      inputCheck();
    });

    document.getElementById("fileCheckBtn").addEventListener('click', function(e) {
      document.getElementById('new-img').remove();
      document.getElementById('no-image').style.width = "120px";;
      document.getElementById('no-image').style.visibility = "visible";
      document.getElementById("fileCheck").value = "";
      inputCheck();
    });
  });
}