<template>
  <b-container class="bv-example-row">
    <b-alert
      :show="dismissCountDown"
      dismissible
      variant="warning"
      @dismissed="dismissCountDown = 0"
      @dismiss-count-down="countDownChanged"
    >
      <p>{{ errorText }}</p>
      <b-progress
        variant="warning"
        :max="dismissSecs"
        :value="dismissCountDown"
        height="4px"
      ></b-progress>
    </b-alert>
    <b-modal
      :no-close-on-backdrop="true"
      id="bv-modal-AddRoom"
      hide-footer
      centered
      title="اضافه کردن اتاق"
    >
      <div class="d-block text-center">
        <b-row class="my-1 row__">
          <b-col sm="4">
            <label for="input-valid"> شماره اتاق</label>
          </b-col>
          <input type="text" v-model="roomid" />
        </b-row>
      </div>
      <b-button
        style="background-color: #2c6eff"
        @click="validateroom"
        class="mt-3"
        block
        >ذخیره</b-button
      >
    </b-modal>
    <b-row>
      <div class="topBar_Chat">
        <div class="Brandbar">
          <span @click="exit" id="menuBTN"><fa-icon icon="arrow-left" /></span>
          <div class="chatInfo">
            <div
              style="
                width: 100%;
                padding-left: 2.5%;
                padding-right: 2.5%;
                text-align: center;
                color: white;
                font-size: 1.5rem;
                display: flex;
                flex-direction: column;
                align-items: center;
                align-content: space-around;
                justify-content: space-between;
              "
            >
              <div id="ChatName">دوربینو</div>
              <div
                style="color: #999 !important; font-size: 15px"
                id="ChatDesc"
              >
                نسخه بیننده
              </div>
            </div>
          </div>
          <span id="SearchBTN"><fa-icon icon="ellipsis-vertical" /></span>
        </div>
      </div>
    </b-row>
    <b-row class="rooww">
      <div class="rooms" v-for="room in rooms" :key="room.code">
        <div class="room">
          <div v-show="room.webcam" class="webcam">
            <video
              autoplay
              controls
              class="remote-video camera"
              :id="`remote-video_${room.id}`"
            ></video>
          </div>
          <div v-show="room.screenshare" class="screen">
            <video
              autoplay
              controls
              class="remote-video screenshare"
              :id="`screen-video_${room.id}`"
            ></video>
          </div>
        </div>
      </div>
    </b-row>
    <!-- <b-button @click="$bvModal.show('bv-modal-AddRoom')" class="addItem"
      >+</b-button
    > -->
  </b-container>
</template>
<script>
import socket from '~/plugins/socket.io.js'
export default {
  data() {
    return {
      dismissSecs: 100,
      dismissCountDown: 0,
      errorText: '',
      roomid: '',
      rooms: [{ id: 0, user: null, webcam: true }],
      peerConnection: null,
      peers: [],
    }
  },
  beforeDestroy() {
    if (this.videoStream) {
      this.videoStream.getTracks().forEach((track) => track.stop())
    }
    socket.off('offer_send')
    socket.off('errorEnterRoom')
    socket.off('errorEnterRoom')
    socket.off('errorValidationRoom')
    socket.off('redirect_')
    socket.off('RedirectToAPP')
  },
  mounted() {
    const { RTCPeerConnection, RTCSessionDescription } = window
    setTimeout(() => {
      socket.emit('validation_room', this.$route.query.id)
    }, 3000)
    this.$root.$emit('CheckSystem')
    socket.on('RedirectToAPP', async (data) => {
      await this.$router.push(`/`)
    })
    socket.on('redirect_', async (data) => {
      this.peerConnection.close()
      await this.$router.push(`/`)
    })
    this.peerConnection = new RTCPeerConnection()
    this.peerConnection.ontrack = function ({ streams: [stream] }) {
      const remoteVideo = document.getElementById('remote-video_0')
      remoteVideo.srcObject = stream
    }
    socket.on('errorValidationRoom', () => {
      console.log('slm')
      this.errorText = 'کد اتاق اشتباه است'
      this.showAlert()
    })
    socket.on('errorEnterRoom', () => {
      console.log('slm')
      this.errorText = 'شما در این اتاق هستید!'
      this.showAlert()
    })
    socket.on('offer_send', (data) => {
      console.log('offer_send')
      this.peerConnection.setRemoteDescription(
        new RTCSessionDescription(data.offer)
      )
      this.peerConnection.createAnswer().then((answer) => {
        this.peerConnection.setLocalDescription(answer)
        return socket.emit('make-answer', {
          answer,
          to: data.socket,
        })
      })
    })
  },
  methods: {
    countDownChanged(dismissCountDown) {
      this.dismissCountDown = dismissCountDown
    },
    showAlert() {
      this.dismissCountDown = this.dismissSecs
    },
    sub() {
      this.rooms.push({ code: null, webcam: true, screenshare: true })
    },
    validateroom() {},
    exit() {
      socket.emit('ExitViewer')
      this.$router.go(-1)
    },
  },
}
</script>
<style>
.camera {
  transform: rotateY(180deg);
  -webkit-transform: rotateY(180deg); /* Safari and Chrome */
  -moz-transform: rotateY(180deg); /* Firefox */
  width: calc(100vh / 2);
  border-radius: 18px;
}
.screenshare {
  width: calc(100vh / 2);
  border-radius: 18px;
}
@import url('https://fonts.googleapis.com/css2?family=Baloo+Bhaijaan+2:wght@600&display=swap');
body {
  background-color: #252b38;
}
.header__ {
  display: flex;
  flex-direction: column;
  align-items: center;
  align-content: space-between;
  flex-wrap: nowrap;
  background-color: #2c6eff;
  border-bottom-right-radius: 30px;
  border-bottom-left-radius: 30px;
  margin-bottom: 3%;
  padding-bottom: 4%;
  color: white;
}
.room {
  color: white;
  /* border: 2px solid; */
  margin-top: 4%;
}
.row {
  justify-content: space-around !important;
}
.addItem {
  position: fixed;
  bottom: 3%;
  right: 3%;
  border-radius: 70%;
  font-size: 20px;
  height: 50px;
  width: 50px;
  background-color: #2c6eff;
  padding: 5px;
}
.row__ {
  flex-direction: row-reverse !important;
}
.rooww {
  display: flex;
  flex-wrap: nowrap;
  margin-right: -15px;
  margin-left: -15px;
  justify-content: center;
  flex-direction: column;
  align-items: center;
  position: fixed;
  top: 9vh;
  width: 100%;
}
.modal-title {
  color: black !important;
}
.close {
  color: black !important;
}
.d-block {
  color: black !important;
}
.d-block label {
  color: black !important;
}
.d-block input {
  color: black !important;
}
</style>
