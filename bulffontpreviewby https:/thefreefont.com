<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Font Demo</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }

    h1 {
      background-color: #333;
      color: white;
      padding: 10px;
      margin: 0;
    }

    form {
      margin-top: 20px;
      padding: 20px;
      background-color: #fff;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      border-radius: 5px;
    }

    label {
      display: block;
      margin-bottom: 10px;
    }

    input[type="file"] {
      margin-bottom: 10px;
    }

    button {
      background-color: #333;
      color: white;
      padding: 10px;
      border: none;
      cursor: pointer;
    }

    button:hover {
      background-color: #555;
    }

    #demo-texts {
      margin-top: 20px;
      display: flex;
      flex-wrap: wrap;
    }

    #demo-texts div {
      font-size: 40px;
      margin: 10px;
      padding: 20px;
      background-color: #fff;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      border-radius: 5px;
    }
  </style>
</head>
<body>
  <h1>Your Font Demo</h1>

  <form action="#" method="post" enctype="multipart/form-data" id="upload-form">
    <label for="font-files">Upload Font Files (.ttf, .otf):</label>
    <input type="file" id="font-files" name="fonts[]" accept=".ttf, .otf" multiple required>
    <button type="button" onclick="loadFonts()">Load Fonts</button>
  </form>

  <div id="demo-texts"></div>

  <script>
    function loadFonts() {
      const fileInput = document.getElementById('font-files');
      const demoTextsContainer = document.getElementById('demo-texts');

      const fontFiles = fileInput.files;
      if (fontFiles.length > 0) {
        demoTextsContainer.innerHTML = ''; // Clear previous demos
        for (let i = 0; i < fontFiles.length; i++) {
          const fontFile = fontFiles[i];
          const reader = new FileReader();

          reader.onload = function (e) {
            const fontUrl = e.target.result;
            const fontFace = new FontFace('CustomFont' + i, url(${fontUrl}));
            fontFace.style.fontSize = '40px'; // Set font size during loading
            document.fonts.add(fontFace);

            fontFace.load().then(function () {
              const demoText = document.createElement('div');
              demoText.style.fontFamily = 'CustomFont' + i;
              demoText.textContent = fontFile.name; // Display font name
              demoTextsContainer.appendChild(demoText);
            });
          };

          reader.readAsDataURL(fontFile);
        }
      } else {
        alert('Please select at least one .ttf or .otf file.');
      }
    }
  </script>
</body>
</html>
